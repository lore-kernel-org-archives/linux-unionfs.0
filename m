Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595A421CC44;
	Thu, 16 Jul 2026 06:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784183010; cv=none; b=rExeNecQ96TY7ORp7/7KdjsM3DydPawX9dXMZSgbRoO+F2/zB2NYJZXW0VAXRmGqykAC9YDhKp5hZ8lIoSocm3WP0Axphy/0XghdQ1XRoLEKaE0NwAME/Y1q0dvNaCqN75rUJCa30ikFmDFgEEq4fsC/uHtn0NkvG5igpKLRpG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784183010; c=relaxed/simple;
	bh=25P0ufuSyK+RM4ZqA3Wd2rjHIIeBUwbwQBVw4Q5qytU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=YoIUUgyJfCaZ3nuQF1brm5fe7WFtHT0rPmnihisJ3AbsJxcQ2jyBcku0fAmunfs3T+uLjlwyuJ21AlKek/XRhFWyUdsho8RdCSYIsycbuOG9AkS+cQjHBGb8mxm/5xP0lsvQx/yi4g7YGN4MWr7Zn+Ny8gd6ZiCNiAYjHt0F+f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=svNjZKuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="svNjZKuv"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8F78C19425;
	Thu, 16 Jul 2026 06:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784183009;
	bh=25P0ufuSyK+RM4ZqA3Wd2rjHIIeBUwbwQBVw4Q5qytU=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=svNjZKuvQmMunG5HQPJnk9jog4EpludshER4O5I4bO1M67KEbHc7ophyfe8GiEc9N
	 dNvlTe9Csk5W5fDvKUtw84obQzF6VsPdPNFnNA9fStpfvv6D7P3wl/8R/IAEYe4tl+
	 AQy+0xlKuCw3AkhyXvaUYry2peD08sET8OOnIyXcjVd0tbJol6arTj80ZoWNLbuNeG
	 6HvnrsmIsKCrtFMH7YvMf0foM/Q2BlhYxSBLGrQQxTR40NwDNGd7wfaoBoKAsxcnWD
	 7dl1GLCxFJxyM1gkWVPb82ZNrXHoHHvxoXWScY1TKqOhUC62uDjJHHa6IGUz4KtkMS
	 y/Z/ryC5/f/gw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD343C44512;
	Thu, 16 Jul 2026 06:23:29 +0000 (UTC)
From: Jesse Van Gavere via B4 Relay <devnull+jesse.vangavere.teledyne.com@kernel.org>
Date: Thu, 16 Jul 2026 08:23:24 +0200
Subject: [PATCH v2] overlayfs.rst: remove mention of workdir needing to be
 empty
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-overlayfs-rst-update-v2-1-ba25393ea7a3@teledyne.com>
X-B4-Tracking: v=1; b=H4sIANt4WGoC/4WNQQ6CMBBFr2Jm7Zi2SSm48h6GRaWD1CAlndJIC
 HcX8AAuX/L++wswRU8M19MCkbJnH4YN1PkETWeHJ6F3G4MSqhBGagyZYm/nljFywml0NhEaLZw
 uTaVaU8E2HSO1/nNk7/WPeXq8qEl7azc6zynE+fjNcvf+XGSJEo0olLaFKUtBt0Q9uXmgSxPeU
 K/r+gWyHr0/zQAAAA==
X-Change-ID: 20260715-overlayfs-rst-update-750d58792f79
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Jesse Van Gavere <jesse.vangavere@teledyne.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784183009; l=1682;
 i=jesse.vangavere@teledyne.com; s=20260715; h=from:subject:message-id;
 bh=cFSfchcWu1ZV/AY69ZArDpiRNyf4mv59SjB1KVkBfnQ=;
 b=TnPAganZkbhxTg0lEDSqsIwbKPHsjAkH9xslf2RsaYF6CRC2TaOznye2mzsaG458syCvjzVbN
 JdC+GOhyuKlB8VCVbz95A6xytbaAy1grE3Er8l4tKOoQiq8j1c/YdDo
X-Developer-Key: i=jesse.vangavere@teledyne.com; a=ed25519;
 pk=OyVy9LsOylefyENuukx/lDTq8X3QaHrhQKS3M67FQic=
X-Endpoint-Received: by B4 Relay for jesse.vangavere@teledyne.com/20260715
 with auth_id=874
X-Original-From: Jesse Van Gavere <jesse.vangavere@teledyne.com>
Reply-To: jesse.vangavere@teledyne.com

From: Jesse Van Gavere <jesse.vangavere@teledyne.com>

This requirement has not been true since v4.8 when automatic cleanup was
added in commit eea2fb4851e9 ("ovl: proper cleanup of workdir")

Signed-off-by: Jesse Van Gavere <jesse.vangavere@teledyne.com>
---
Changes in v2:
- Handle remark from Amir Goldstein to drop workdir cleanup reference
- Link to v1: https://patch.msgid.link/20260715-overlayfs-rst-update-v1-1-70625a67880e@teledyne.com

To: Miklos Szeredi <miklos@szeredi.hu>
To: Amir Goldstein <amir73il@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-unionfs@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/filesystems/overlayfs.rst | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index eb846518e6ac..ba41c0694e62 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -123,8 +123,7 @@ At mount time, the two directories given as mount options "lowerdir" and
   mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,\
   workdir=/work /merged
 
-The "workdir" needs to be an empty directory on the same filesystem
-as upperdir.
+The "workdir" needs to be a directory on the same filesystem as upperdir.
 
 Then whenever a lookup is requested in such a merged directory, the
 lookup is performed in each actual directory and the combined result

---
base-commit: 58717b2a1365d06c8c64b72aa948541b53fe31eb
change-id: 20260715-overlayfs-rst-update-750d58792f79

Best regards,
--  
Jesse Van Gavere <jesse.vangavere@teledyne.com>


