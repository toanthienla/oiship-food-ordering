INSERT INTO Admin(name, email, password, created_at)
VALUES ('Admin', 'oiship.team@gmail.com',
        '$2a$12$sxxt7Bu2u/tYKPAks5cno.pr1p2oC00KKo8K3RcvUqQP8BXrAp6sW', -- password = admin
        GETDATE());

INSERT INTO UserStatus (status_id, status_name, description) VALUES
(0, 'not_verified', 'Account has not been verified via email'),
(1, 'active', 'Account is active'),
(2, 'pending_approval', 'Account is awaiting approval (Shipper/Restaurant)'),
(3, 'banned', 'Account is banned'),
(4, 'online', 'Shipper is online'),
(5, 'offline', 'Shipper is offline'),
(6, 'delivering', 'Shipper is delivering');