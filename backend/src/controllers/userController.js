const User = require('../models/User');

const PHONE_REGEX = /^(?:\+91)?[6-9]\d{9}$/;

const normalizePhone = (phone) => {
  if (!phone) return '';
  const cleaned = phone.replace(/[\s\-]/g, '');
  if (cleaned.startsWith('+91')) {
    return cleaned;
  }
  if (cleaned.length === 10 && /^[6-9]\d{9}$/.test(cleaned)) {
    return `+91${cleaned}`;
  }
  return cleaned;
};

/**
 * GET /api/v1/users/profile
 * Retrieve authenticated user profile
 */
const getProfile = async (req, res, next) => {
  try {
    const user = await User.findById(req.user._id);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User profile not found' });
    }
    return res.status(200).json({
      success: true,
      data: user.toJSON(),
    });
  } catch (error) {
    next(error);
  }
};

/**
 * PUT or PATCH /api/v1/users/profile
 * Update editable profile fields: name, city, bio, profileImage
 * Strictly ignores and protects sensitive/system fields
 */
const updateProfile = async (req, res, next) => {
  try {
    const { name, city, profileImage, bio } = req.body;
    const user = await User.findById(req.user._id);

    if (!user) {
      return res.status(404).json({ success: false, message: 'User profile not found' });
    }

    if (name !== undefined) {
      if (typeof name !== 'string' || name.trim().length === 0) {
        return res.status(400).json({ success: false, message: 'Name cannot be empty' });
      }
      user.name = name.trim();
    }

    if (city !== undefined) {
      if (typeof city !== 'string' || city.trim().length === 0) {
        return res.status(400).json({ success: false, message: 'City cannot be empty' });
      }
      user.city = city.trim();
    }

    if (bio !== undefined) {
      if (typeof bio !== 'string') {
        return res.status(400).json({ success: false, message: 'Bio must be a string' });
      }
      if (bio.length > 140) {
        return res.status(400).json({ success: false, message: 'Bio cannot exceed 140 characters' });
      }
      user.bio = bio.trim();
    }

    if (profileImage !== undefined) {
      user.profileImage = typeof profileImage === 'string' ? profileImage.trim() : '';
    }

    await user.save();

    return res.status(200).json({
      success: true,
      message: 'Profile updated successfully',
      data: user.toJSON(),
    });
  } catch (error) {
    next(error);
  }
};

/**
 * PUT /api/v1/users/preferences
 * Update user travel and notification preferences
 */
const updatePreferences = async (req, res, next) => {
  try {
    const { notifications, allowSmoking, allowPets } = req.body;
    const user = await User.findById(req.user._id);

    if (!user) {
      return res.status(404).json({ success: false, message: 'User profile not found' });
    }

    if (!user.preferences) {
      user.preferences = { notifications: true, allowSmoking: false, allowPets: false };
    }

    if (notifications !== undefined) {
      if (typeof notifications !== 'boolean') {
        return res.status(400).json({ success: false, message: 'notifications preference must be a boolean' });
      }
      user.preferences.notifications = notifications;
    }
    if (allowSmoking !== undefined) {
      if (typeof allowSmoking !== 'boolean') {
        return res.status(400).json({ success: false, message: 'allowSmoking preference must be a boolean' });
      }
      user.preferences.allowSmoking = allowSmoking;
    }
    if (allowPets !== undefined) {
      if (typeof allowPets !== 'boolean') {
        return res.status(400).json({ success: false, message: 'allowPets preference must be a boolean' });
      }
      user.preferences.allowPets = allowPets;
    }

    user.markModified('preferences');
    await user.save();

    return res.status(200).json({
      success: true,
      message: 'Preferences updated successfully',
      data: user.preferences,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * GET /api/v1/users/emergency-contacts
 * List all emergency contacts for authenticated user
 */
const getEmergencyContacts = async (req, res, next) => {
  try {
    const user = await User.findById(req.user._id);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User profile not found' });
    }

    return res.status(200).json({
      success: true,
      data: user.emergencyContacts || [],
    });
  } catch (error) {
    next(error);
  }
};

/**
 * POST /api/v1/users/emergency-contacts
 * Add a new emergency contact
 */
const addEmergencyContact = async (req, res, next) => {
  try {
    const { name, phone, relationship } = req.body;

    if (!name || typeof name !== 'string' || name.trim().length === 0) {
      return res.status(400).json({ success: false, message: 'Contact name is required' });
    }

    if (!phone || typeof phone !== 'string') {
      return res.status(400).json({ success: false, message: 'Contact phone is required' });
    }

    const cleanPhone = phone.trim().replace(/[\s\-]/g, '');
    if (!PHONE_REGEX.test(cleanPhone)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid phone number format. Must be a valid 10-digit Indian mobile number.',
      });
    }

    const normalizedPhone = normalizePhone(cleanPhone);
    const user = await User.findById(req.user._id);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User profile not found' });
    }

    const newContact = {
      name: name.trim(),
      phone: normalizedPhone,
      relationship: relationship && typeof relationship === 'string' ? relationship.trim() : 'Family',
    };

    user.emergencyContacts.push(newContact);
    await user.save();

    const createdContact = user.emergencyContacts[user.emergencyContacts.length - 1];

    return res.status(201).json({
      success: true,
      message: 'Emergency contact added successfully',
      data: createdContact,
      emergencyContacts: user.emergencyContacts,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * PUT /api/v1/users/emergency-contacts/:id
 * Update an existing emergency contact
 */
const updateEmergencyContact = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { name, phone, relationship } = req.body;

    const user = await User.findById(req.user._id);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User profile not found' });
    }

    const contact = user.emergencyContacts.id(id);
    if (!contact) {
      return res.status(404).json({ success: false, message: 'Emergency contact not found' });
    }

    if (name !== undefined) {
      if (typeof name !== 'string' || name.trim().length === 0) {
        return res.status(400).json({ success: false, message: 'Contact name cannot be empty' });
      }
      contact.name = name.trim();
    }

    if (phone !== undefined) {
      const cleanPhone = phone.trim().replace(/[\s\-]/g, '');
      if (!PHONE_REGEX.test(cleanPhone)) {
        return res.status(400).json({
          success: false,
          message: 'Invalid phone number format. Must be a valid 10-digit Indian mobile number.',
        });
      }
      contact.phone = normalizePhone(cleanPhone);
    }

    if (relationship !== undefined) {
      contact.relationship = typeof relationship === 'string' ? relationship.trim() : 'Family';
    }

    await user.save();

    return res.status(200).json({
      success: true,
      message: 'Emergency contact updated successfully',
      data: contact,
      emergencyContacts: user.emergencyContacts,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * DELETE /api/v1/users/emergency-contacts/:id
 * Remove an emergency contact
 */
const deleteEmergencyContact = async (req, res, next) => {
  try {
    const { id } = req.params;

    const user = await User.findById(req.user._id);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User profile not found' });
    }

    const contact = user.emergencyContacts.id(id);
    if (!contact) {
      return res.status(404).json({ success: false, message: 'Emergency contact not found' });
    }

    contact.deleteOne();
    await user.save();

    return res.status(200).json({
      success: true,
      message: 'Emergency contact deleted successfully',
      emergencyContacts: user.emergencyContacts,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getProfile,
  updateProfile,
  updatePreferences,
  getEmergencyContacts,
  addEmergencyContact,
  updateEmergencyContact,
  deleteEmergencyContact,
};
