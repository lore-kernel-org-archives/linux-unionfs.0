Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A8D253327;
	Tue, 29 Apr 2025 18:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745951949; cv=none; b=nKuuntSb9Wcul2TNb4au4r7TM2lHwcSpr7JWAMxcnwbGA2BZ0koY3YRiTnFi2nIRKqQ16dEFAHyssfoRtYXkOAwnjv3Uo9fFITPXpU1a5ad1cERZAkYNn7THe+v3ia7rkjmf96eNuvwEl/qDXBNFDuKb0dzY6ieOvfftarSzE/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745951949; c=relaxed/simple;
	bh=5YbLaOs5gXsthXYJOmJ/FPiOamGCMqnR/Us/NOKqFl8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ClxAQ50jFo4GL0kLGw/5c8VZaUg8rYQObU87FAI2vr0U8KHZy4D2IPZ5YvhtbJhppSxA2IKJ+rdKWmRo8QdrmBMoc1RehTKWM71YcEall8ooFNchnrsXbQPfMmAB4Ja70YYfdGGOFLq/LPVCRHGnYFfNZKhHKAVxWw7H46I9+/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=RyksyaEf; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="RyksyaEf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0h6hoXkmjU5AmVBsb0V67b5Gl6LVa3ZnChQF6D6Vrq0=; b=RyksyaEfVeDDBo05RuUstfOVlS
	S+dncbb8oJax9axyub40tnkmq8gIfofXE13vb7K7OMGapTa2VzhemFqDBMC/DNthXb84wY+omO9n8
	1ZUQ+e5zN+WAd8r2qSmYjYrklfEK2MEJ6cQ+4ylVVkPl32xHOPGTmW5LNpuuzmQzR0OZevqrcs++1
	6fGLdf6/URWlC7cO4JMAH9Gz9z5DDCAdgtzAfn2Uv5rAe9T/DFDVOnw1zL020veViXMrcuHPDNLJl
	fPTXR+dEUDEptrqr/hW7Jhn05Ui4mEM6NUq/C1K6xa0wBLF6I8ZfIkJWmuzoSh7S9O0U/Y5OQgo2k
	uSluJ92g==;
Received: from [191.204.192.64] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1u9pqj-000Swz-Ug; Tue, 29 Apr 2025 20:39:00 +0200
From: =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	John Schoenick <johns@valvesoftware.com>
Subject: [PATCH] ovl: Fix nested backing file paths
Date: Tue, 29 Apr 2025 15:38:50 -0300
Message-ID: <20250429183850.211682-1-andrealmeid@igalia.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When the lowerdir of an overlayfs is a merged directory of another
overlayfs, ovl_open_realfile() will fail to open the real file and point
to a lower dentry copy, without the proper parent path. After this,
d_path() will then display the path incorrectly as if the file is placed
in the root directory.

This bug can be triggered with the following setup:

 mkdir -p ovl-A/lower ovl-A/upper ovl-A/merge ovl-A/work
 mkdir -p ovl-B/upper ovl-B/merge ovl-B/work

 cp /bin/cat ovl-A/lower/

 mount -t overlay overlay -o \
 lowerdir=ovl-A/lower,upperdir=ovl-A/upper,workdir=ovl-A/work \
 ovl-A/merge

 mount -t overlay overlay -o \
 lowerdir=ovl-A/merge,upperdir=ovl-B/upper,workdir=ovl-B/work \
 ovl-B/merge

 ovl-A/merge/cat /proc/self/maps | grep --color cat
 ovl-B/merge/cat /proc/self/maps | grep --color cat

The first cat will correctly show `/ovl-A/merge/cat`, while the second
one shows just `/cat`.

To fix that, uses file_user_path() inside of backing_file_open() to get
the correct file path for the dentry.

Co-developed-by: John Schoenick <johns@valvesoftware.com>
Signed-off-by: John Schoenick <johns@valvesoftware.com>
Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 fs/overlayfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 969b458100fe..dfea7bd800cb 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -48,8 +48,8 @@ static struct file *ovl_open_realfile(const struct file *file,
 		if (!inode_owner_or_capable(real_idmap, realinode))
 			flags &= ~O_NOATIME;
 
-		realfile = backing_file_open(&file->f_path, flags, realpath,
-					     current_cred());
+		realfile = backing_file_open(file_user_path((struct file *) file),
+					     flags, realpath, current_cred());
 	}
 	ovl_revert_creds(old_cred);
 
-- 
2.49.0

