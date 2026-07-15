Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75502F1FEA;
	Wed, 15 Jul 2026 13:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784123560; cv=none; b=K02O4WA+NUfOaLFgOK1b4bNRKCEv7S7L29dy+trMez8+5SAx29g/SPyE9NUcrzM/ambBux1MAD/Vu1p7dG5aI4TMS9F8SNL+kXL3LWfhrd0NXSEm/lHhyNrOrFSCXF4xNpOSvcpqJQkjU/nIYDYFeBgew/QzZrh3l/jTl8YbB/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784123560; c=relaxed/simple;
	bh=lN49TiTB/g6ecfIr+YcKzShlcTcWnDCtDQR1rDYyl/E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ALtcWnv4KYapTt01gsgskB6Fbf/zWzjW0U+4BHQaaY6xRPCkh7bop44HCcyfkeDGHh2tvl/2XiEvWuyLKNyRs72FHArxDgwhe6vIXvZYkBovCLyjM54ZMGI/YwQnCFfk1HkgC8JFhzbjOKao1/MJL4d2qNRBCBK6W8O5ZG51EVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hJb0q8FK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJb0q8FK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B597C19425;
	Wed, 15 Jul 2026 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784123560;
	bh=lN49TiTB/g6ecfIr+YcKzShlcTcWnDCtDQR1rDYyl/E=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=hJb0q8FKh/l3LeYivEC3/32GbH3kfBAzNIP0KiUrl4wyeeHKbihuVDQ7Bz+8El21a
	 JYrmQor582MYZgnpCnVxqEvCPPInexCNuYPAMizV75rCCzO9flIyrOKAJsFV/I6Ml5
	 x3Cjtr8l9+JWjVXIEMXUV4frzZWPk7d8RLov0q+V3OMmYODBsyZ2/mEMGMwPr0N+YL
	 mkq7WgYr4cqP22TPzpSfN5x8wTVetfIeU63/vODuOEsACxfSKZ8viHVkQVE9oUM+dc
	 6aWzV8AGJRWBBcYG69BIUPMgfsoizBnFCPQb85fQ9VZWF7N4Slaht9YUdLIJpYAS3h
	 5OlcT4RubvOuA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B02C4450A;
	Wed, 15 Jul 2026 13:52:40 +0000 (UTC)
From: Jesse Van Gavere via B4 Relay <devnull+jesse.vangavere.teledyne.com@kernel.org>
Date: Wed, 15 Jul 2026 15:52:23 +0200
Subject: [PATCH] overlayfs.rst: remove mention of workdir needing to be
 empty
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260715-overlayfs-rst-update-v1-1-70625a67880e@teledyne.com>
X-B4-Tracking: v=1; b=H4sIAJaQV2oC/yXMQQqDMBBA0avIrDsQA2m0VyldpGZSpxSVmSgW8
 e6NdvkW/2+gJEwKt2oDoYWVx6GgvlTQ9WF4EXIsBmvs1fja4biQfMI3KYpmnKcYMqF3JrrGtzb
 5Fko6CSVez+398bfOzzd1+XjBvv8Ag6T3KHgAAAA=
X-Change-ID: 20260715-overlayfs-rst-update-750d58792f79
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Jesse Van Gavere <jesse.vangavere@teledyne.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784123559; l=1253;
 i=jesse.vangavere@teledyne.com; s=20260715; h=from:subject:message-id;
 bh=u9yuA8upX2scbp+cidGFdg1BSQtMNSI8cIdYLedjGX8=;
 b=qv4gFHFYbdGjveHk4GLTgLd/6es9PkHo7mg6Eot1a7EVHsS6F9+cDnr5lSdqpu5vGShJRwpQA
 OJflxTqoUmPCm574m3J/Odsy1db/6+kXKN12+iuf135IOnU5p05aUDD
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
 Documentation/filesystems/overlayfs.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index eb846518e6ac..7e28bfb4a99e 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -123,8 +123,8 @@ At mount time, the two directories given as mount options "lowerdir" and
   mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,\
   workdir=/work /merged
 
-The "workdir" needs to be an empty directory on the same filesystem
-as upperdir.
+The "workdir" will be cleaned up at mount time and needs to be on the same
+filesystem as upperdir.
 
 Then whenever a lookup is requested in such a merged directory, the
 lookup is performed in each actual directory and the combined result

---
base-commit: 58717b2a1365d06c8c64b72aa948541b53fe31eb
change-id: 20260715-overlayfs-rst-update-750d58792f79

Best regards,
--  
Jesse Van Gavere <jesse.vangavere@teledyne.com>


