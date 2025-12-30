// VIOLATION: Interface Segregation Principle (ISP)
// This component has a fat props interface with multiple responsibilities:
// - Display props
// - Edit props
// - Admin props
// - Analytics props
// Components are forced to accept props they don't use - violates ISP

import React, { useEffect } from 'react';
import type { User, AdminAction } from '../types';

interface UserProfileProps {
  // Display props
  name: string;
  email: string;
  avatar?: string;
  
  // Edit props (not always needed)
  onEditName?: (name: string) => void;
  onEditEmail?: (email: string) => void;
  onEditAvatar?: (avatar: string) => void;
  
  // Admin props (rarely needed)
  isAdmin?: boolean;
  adminActions?: AdminAction[];
  onAdminAction?: (action: AdminAction) => void;
  
  // Analytics props (not always needed)
  trackView?: () => void;
  trackInteraction?: (event: string) => void;
}

export const UserProfile: React.FC<UserProfileProps> = ({
  name,
  email,
  avatar,
  onEditName,
  onEditEmail,
  onEditAvatar,
  isAdmin,
  adminActions,
  onAdminAction,
  trackView,
  trackInteraction,
}) => {
  // VIOLATION: Forced to use analytics even if not needed
  useEffect(() => {
    if (trackView) {
      trackView();
    }
  }, [trackView]);

  const handleInteraction = (event: string) => {
    if (trackInteraction) {
      trackInteraction(event);
    }
  };

  return (
    <div className="user-profile">
      <div className="user-display">
        {avatar && <img src={avatar} alt={name} className="avatar" />}
        <h2>{name}</h2>
        <p>{email}</p>
      </div>

      {/* Edit section - only needed sometimes */}
      {(onEditName || onEditEmail || onEditAvatar) && (
        <div className="user-edit">
          <h3>Edit Profile</h3>
          {onEditName && (
            <div>
              <label>Name:</label>
              <input
                type="text"
                value={name}
                onChange={(e) => {
                  onEditName(e.target.value);
                  handleInteraction('name_edited');
                }}
              />
            </div>
          )}
          {onEditEmail && (
            <div>
              <label>Email:</label>
              <input
                type="email"
                value={email}
                onChange={(e) => {
                  onEditEmail(e.target.value);
                  handleInteraction('email_edited');
                }}
              />
            </div>
          )}
          {onEditAvatar && (
            <div>
              <label>Avatar URL:</label>
              <input
                type="text"
                value={avatar || ''}
                onChange={(e) => {
                  onEditAvatar(e.target.value);
                  handleInteraction('avatar_edited');
                }}
              />
            </div>
          )}
        </div>
      )}

      {/* Admin section - only needed for admins */}
      {isAdmin && adminActions && onAdminAction && (
        <div className="admin-panel">
          <h3>Admin Actions</h3>
          {adminActions.map(action => (
            <button
              key={action.id}
              onClick={() => {
                onAdminAction(action);
                handleInteraction(`admin_action_${action.id}`);
              }}
              className="admin-action-btn"
            >
              {action.label}
            </button>
          ))}
        </div>
      )}
    </div>
  );
};

