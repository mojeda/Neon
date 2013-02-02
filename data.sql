CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `username` varchar(65) NOT NULL,
  `email` varchar(65) NOT NULL,
  `active` int(1) NOT NULL,
  `activation_code` varchar(65) NOT NULL,
  `plan` int(8) NOT NULL,
  `initial_setup` int(1) NOT NULL DEFAULT '0',
  `stats_email` int(1) NOT NULL,
  `welcome_closed` int(1) NOT NULL,
  `max_list_files` int(8) NOT NULL DEFAULT '-1',
  `save_sort_files` int(2) NOT NULL DEFAULT '0',
  `default_editor` varchar(65) NOT NULL DEFAULT 'default',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `username`, `email`, `active`, `activation_code`, `plan`, `initial_setup`, `stats_email`, `welcome_closed`, `max_list_files`, `save_sort_files`, `default_editor`) VALUES
(4, 'root', 'admin@localhost', 1, '', 1, 0, 0, 0, 0, 0, 'default');

-- --------------------------------------------------------

--
-- Table structure for table `domains`
--

CREATE TABLE IF NOT EXISTS `domains` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `user_id` int(8) NOT NULL,
  `domain_name` varchar(65) NOT NULL,
  `active` int(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=42 ;

--
-- Dumping data for table `domains`
--

INSERT INTO `domains` (`id`, `user_id`, `domain_name`, `active`) VALUES
(41, 18, 'localhost', 1);

-- --------------------------------------------------------

--
-- Table structure for table `plans`
--

CREATE TABLE IF NOT EXISTS `plans` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `name` varchar(65) NOT NULL,
  `max_domains` int(8) NOT NULL,
  `max_parked_domains` int(8) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `setting_name` varchar(65) NOT NULL,
  `setting_value` varchar(65) NOT NULL,
  `setting_group` varchar(65) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `setting_name`, `setting_value`, `setting_group`) VALUES
(1, 'template', 'blue_default', 'design_settings'),
(2, 'panel_title', 'NEON', 'panel_settings'),
(3, 'registration_enabled', 'enabled', 'panel_settings'),
(4, 'forgotpassword_enabled', 'enabled', 'panel_settings'),
(5, 'default_ip', 'localhost', 'panel_settings'),
(6, 'max_panel_upload_size', '25MB', 'panel_settings');
