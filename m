Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489793AB46F;
	Mon, 15 Jun 2026 13:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529630; cv=none; b=MWz4zmycxejLGRKLT5AYTiIfPORTUWvoeDRefJkYXPL6R2fjwmBPIYpTr/NPK80c1YApJbpbSXdA8Zlfvf7Td6fFcRRVDK8cBnr9xrMLwYO4epCbEiF/Pt40YWeiDOa3DoWMzERMGT1uyi315gKyXfg4Z4cMvTH9tD21DTIqrEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529630; c=relaxed/simple;
	bh=mQ/hJHvgl9mNLkKVOt5DLGXga5F91m0iIbi4ySkFDXQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rLYTox6b9kVVUJR+CftHB3/ppmVKG+3xNIpxU65o1j9NkLggC9lBUA2klfmxdKqNfgDh6xpCNobNbNbW+wSxSnKPzx+DsfRvsHtbqKmdjT9+JEKC5r/vwZERNdOC7lyQ2d05wSGuHfRMLwwAtaf0c4g5cLJ/Tw+umwoc8qRrxLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9YVXwLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9YVXwLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07551F00A3D;
	Mon, 15 Jun 2026 13:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529628;
	bh=VQavoy9fpArGebqSCiw7oY8aVDn+Q0C/J7k7LK8uQSo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K9YVXwLxVZtIiw2FgALiqSeabc1EZJjsQQt4S2CW8MHqZbPKREYGZJwyffZ//WK3R
	 JyYjQZzf6MyQM6bpKAjMPDpALlw7SlSHLuetSKu3JycJh+vNF0EdQsQ969JC2MuguX
	 7Z4uDny+5o1fXKT6uX9DePLtB+63SF93Km7+gyopZGa27qPv5t2S7a/2uBzNK2CJvM
	 SdHiKUn5+jYhTfVRpTu+MgfqGIoUcor0Kt50e5oF5ui/IMqswlJSGvowBfVVGi60T6
	 Ox6qWnIN/jCOS95pSN2vlcOg5tpqI12OIMQJYKXqq6JT0LhythGdcsgnZkjXFwThdn
	 Y3u20MJo3hHZg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:19:56 +0200
Subject: [PATCH 07/10] docs: document idmapped overlay mounts
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-idmapped-overlayfs-v1-7-7381632aa402@kernel.org>
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
In-Reply-To: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=1646; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mQ/hJHvgl9mNLkKVOt5DLGXga5F91m0iIbi4ySkFDXQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/+E9+pWjVDDkQeGppS92/PPwajmSe46fITF9f+l6q
 QAhN+npHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABO5sojhf87deWled2sDgu0m
 T/O2vCKR33NNaM0n5XXaTKeuGHqocjD8dw9iMFswJc3ywWOZN8WLsvJs9Fn/dpVOSXz58m2b1uQ
 d3AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Describe that the merged overlay mount itself can be turned into an
idmapped mount with mount_setattr(2), how the overlay mount idmapping
composes with any layer idmappings, and that the mounter's access to
the underlying layers is unaffected.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/overlayfs.rst | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index eb846518e6ac..1a29a5afabd7 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -347,6 +347,22 @@ The resulting access permissions should be the same.  The difference is in
 the time of copy (on-demand vs. up-front).
 
 
+Idmapped mounts
+---------------
+
+The overlay mount itself can be turned into an idmapped mount by applying an
+idmapping to it with mount_setattr(2) and MOUNT_ATTR_IDMAP, just like for
+other filesystems that support idmapped mounts.
+
+The mount idmapping only changes how ownership and permissions of the overlay
+inodes are presented to and interpreted for the caller.  It does not change
+how overlayfs accesses the underlying layers: those are still accessed with
+the stashed mounter's credentials through their own mounts, which may
+themselves be idmapped.  The overlay mount idmapping and any layer idmapping
+compose, an underlying id is first mapped according to the relevant layer
+idmapping and then according to the overlay mount idmapping.
+
+
 Multiple lower layers
 ---------------------
 

-- 
2.47.3

