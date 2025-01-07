Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [195.130.137.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D221E2842
	for <linux-unionfs@vger.kernel.org>; Tue,  7 Jan 2025 08:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.137.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736239484; cv=none; b=pPdWMrFjBQ622GsZhztWB/v9K/Z/0SjJiuKNuTD5woSnJQkxPznei9e8uTG/dS/sTUbhEsbRt+Z0g4Im/Yul9pwA70dDz6y4arulIOvJh1XXlAn+2fUUWh8ydrg86LSFMpVa9dmPCb67yTShuHOb1rAI2b0o1MqsoYR3Mnk9Klg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736239484; c=relaxed/simple;
	bh=5P9iZOWC+nkrEWb3FOIQ8gioITybKsrDoTgdL1L/wyU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mhz0/6oylf7gBGfcXhBhDyzO8xnDTG6RXFEglElJ4V5NEie2Bzb6KVqmpo8VLjnngu62nQuixR/b2Qd8o9eRGEe0gBXS7eQ5Hfcj1VlL1lVoGmvcKVvquk5Xq6IWss9kEG0KyluVOun2jB6frY07OTGSLpaKoNj9m/gU4U2LYoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.137.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:39d4:dc4e:b4ce:1377])
	by laurent.telenet-ops.be with cmsmtp
	id y8kZ2D00U3AZZFy018kZWv; Tue, 07 Jan 2025 09:44:35 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tV5CP-00000008Zi0-3z6C;
	Tue, 07 Jan 2025 09:44:33 +0100
Received: from geert by rox.of.borg with local (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tV5CT-00000004lQd-20pE;
	Tue, 07 Jan 2025 09:44:33 +0100
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-unionfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] overlayfs.rst: Fix and improve grammar
Date: Tue,  7 Jan 2025 09:44:28 +0100
Message-ID: <cf07f705d63f04ebf7ba4ecafdc9ab6f63960e3d.1736239148.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  - Correct "in a way the" to "in a way that",
  - Add a comma to improve readability.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/filesystems/overlayfs.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 4c8387e1c88068fa..a93dddeae199491a 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -266,7 +266,7 @@ Non-directories
 Objects that are not directories (files, symlinks, device-special
 files etc.) are presented either from the upper or lower filesystem as
 appropriate.  When a file in the lower filesystem is accessed in a way
-the requires write-access, such as opening for write access, changing
+that requires write-access, such as opening for write access, changing
 some metadata etc., the file is first copied from the lower filesystem
 to the upper filesystem (copy_up).  Note that creating a hard-link
 also requires copy_up, though of course creation of a symlink does
@@ -549,8 +549,8 @@ Nesting overlayfs mounts
 
 It is possible to use a lower directory that is stored on an overlayfs
 mount. For regular files this does not need any special care. However, files
-that have overlayfs attributes, such as whiteouts or "overlay.*" xattrs will be
-interpreted by the underlying overlayfs mount and stripped out. In order to
+that have overlayfs attributes, such as whiteouts or "overlay.*" xattrs, will
+be interpreted by the underlying overlayfs mount and stripped out. In order to
 allow the second overlayfs mount to see the attributes they must be escaped.
 
 Overlayfs specific xattrs are escaped by using a special prefix of
-- 
2.43.0

