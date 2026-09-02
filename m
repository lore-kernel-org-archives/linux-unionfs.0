Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90DC4AA58D
	for <linux-unionfs@vger.kernel.org>; Wed,  2 Sep 2026 19:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377696; cv=none; b=l8vyFXLKky6/T38qwrHyWhWyMIUM+fELUEYmzUfcBEfxPebgYop7iLUULtJkPr2TiAnZwiw37zcRRlm8CdEk2tX4/8LQQsh1ea3OZYxjoi0ZzDSTBaJt2wzaT8xvJnP7frwTJ0y7ZH370vmndb7sjQZxA+iUrfmGDVZcU9aWrlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377696; c=relaxed/simple;
	bh=eh+it0zb54ufEP/JnblEMEpySL7Prj/F5s/H28111ro=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=Lna0KyIhQ8x8sTn5V/o+cGxDrv4338bQztBbh6VaNex4E1NosvE+Y9M7Tn2sfXaCnxfRLtRwjhIXC5U6AIpNUTBMdFuGm8itasOGa8epQ0583qNZ2AaCfcZvLc/Do1OzxhDGvSM4cHSsphJ1MMo+O5ULYbKaQd7pui5yMvbMEKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=BApmi94N; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="BApmi94N"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-90ccb6102a1so12547036d6.3
        for <linux-unionfs@vger.kernel.org>; Wed, 02 Sep 2026 12:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1788377687; x=1788982487; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GJ6syoQl7zUGKH+u6+bqTcHjjLcFH2wSt0NVpBp7lDc=;
        b=BApmi94N0haia63+fWtF0lO8gtf7CPbnhyiBUjO2IH+nYwAJb4uJXYRK7Cr6JJKpFk
         YxGptCgPyiA1YZmnPhS3FOGlqVAlbkwTb/eVF5NtLCuLuSICFUx37nq/Nns4yNA2zgH0
         CFYc13B4d2J1cC4nKVeZUp+yNmFJrn0DoYd6ScYOlVDpCIQWM8wV9IJ51HJQi6KW+GVF
         nI2FzCFnKFMfXHpWkki8P6hmZ4q8a2BhC/Xez0+PIPWLa+R4Uc0B91tXHiwfcP+6AsP1
         FRMH/M4HjtVOxsSROaRN5mJYZjmLY8FnTjlOzEo1VRpzChFgoAHEReRUhVrJL43U/Yma
         Kkhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377687; x=1788982487;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GJ6syoQl7zUGKH+u6+bqTcHjjLcFH2wSt0NVpBp7lDc=;
        b=s6uJ1stgvaAkSupMZX6WfuJLwRmrwcUgjlip4F+xT3w58STKeLGK179b0iYacvHUyX
         kETawZsABPscC4ucvNRPbSKEHNRlzEXVUPkpT8fb9HZqBr8HlLFaozlhlJeOUPu60z52
         FtTKRlrboBNv3jKPRk86K0VAlpAcb2u0c0YTAcMzJNcPAAqE96fqC7SZo8z4u9ZEu4bi
         VFPaKhBJ/uJcyOlcx0V7ETT3IBxXrbP2zFh1CnklyEhhV7jOi17jZFZ0hSRsNojWrxtY
         3RpoVGS6pakYMnbuKisKn2VriYiMaWzvA/6EszF/6QzUG2+6V9ynD03U9Dk9FoLQD50T
         A49Q==
X-Forwarded-Encrypted: i=1; AKwUvByLui208kdirBYVybwZ6ocXyrR30XUyFMvFfGCEFo7KiSFAS3+M9z5qhLZiLnC0VgsKAo/ov/2i/OZG92ye@vger.kernel.org
X-Gm-Message-State: AFuF++kn5mslKtj9IqaIANoKDzHHPmpk85sh3QfK+l8t2NtLO/baXZqb
	eldUnnvQfgBJ5yQ7AEdYfl137eqIXCJrS5tivrro3KAVdC8pOGUNDgdR50fZWqqFOg==
X-Gm-Gg: AYBFou3btAusDHAdix0GVG2MaOs7eklwEnd9MDXu7RG35V/fAHjGj2zkLQ0lFhw5ONf
	eRvCi1Gkji0tixuMAzZE7nbMZM6XjxKfHHVU1H5fPS1pH0/9r4+nGu5Awv7gMxIuGHoqD9Bq1/s
	zGCkf0ooCNn/N55tQmoCIgGY/tLJiOJ62DxE9gZrLjiGPhGYmkNL61sF9Yh6A6NFoD1bkgxUho0
	6iSsdOdwBNCO6XkiKSc8GbBSAh+qR5177s+5/r6OlLIBhQliGkWnjJ3wQfOEhUUCGmuOGJTcTaS
	3v0k6BUkSFKmxk7AviZmasMzj5EaZUX71ETBGAJCtoMz2prINmw0NkMO4nSjZBC36qUcnRnJGz2
	abGGLZMDJ9VBrKOVciuB+ShKp0BXuwn6VN0A4L4Cvp6XAdpBFZ0lRJ4xnXZmHi04DUpOGhr9eqJ
	qbdFj6qFxP8VGOD1hcWo4vp6q2XARVhVbtEct3Bpb2RSAicBDv0kQ6OCWMlDnPrPOGQdiof4x4D
	vngDQ0EV7sryJuSxYcM7yYzZ9ib5QlS+Q==
X-Received: by 2002:a05:6214:e85:b0:90e:7de2:d81f with SMTP id 6a1803df08f44-90ebabbac8emr90744936d6.20.1788377687526;
        Wed, 02 Sep 2026 12:34:47 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9ee08710sm25176366d6.2.2026.09.02.12.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:34:46 -0700 (PDT)
Date: Wed, 02 Sep 2026 15:34:46 -0400
Message-ID: <e266759fa7a20e9620b16c1b5a717744@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20260902_1319/pstg-lib:20260901_1604/pstg-pwork:20260902_1319
From: Paul Moore <paul@paul-moore.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Seth Forshee <sforshee@kernel.org>, linux-security-module@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: Re: [PATCH 11/27] fs: port acl to const mnt_idmap
References: <20260901-work-idmap-const-v1-11-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-11-54ccd48e100b@kernel.org>

On Sep  1, 2026 Christian Brauner <brauner@kernel.org> wrote:
> 
> Convert to const struct mnt_idmap.
> 
> A mount's idmapping is immutable. The only thing that is allowed to be
> modified afterwards is the reference count and that is hidden behind
> mnt_idmap_get() and mnt_idmap_put(). Everything else only ever reads
> from the idmapping. This is the same model that struct cred uses and the
> idmapping is also rather sensitive.
> 
> So make the idmap argument const wherever we can. The conversion is done
> from the bottom up so callers can continue to pass a non-const pointer
> to a const parameter until the conversion is finished.
> 
> No functional changes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ntfs/ea.c                          |  4 ++--
>  fs/ntfs/ea.h                          |  2 +-
>  fs/ntfs/namei.c                       |  2 +-
>  fs/ntfs3/inode.c                      |  2 +-
>  fs/ntfs3/ntfs_fs.h                    |  4 ++--
>  fs/ntfs3/xattr.c                      |  4 ++--
>  fs/posix_acl.c                        |  6 +++---
>  include/linux/lsm_hook_defs.h         |  8 ++++----
>  include/linux/posix_acl.h             |  4 ++--
>  include/linux/security.h              | 16 ++++++++--------
>  security/integrity/evm/evm_main.c     | 10 +++++-----
>  security/integrity/ima/ima_appraise.c |  4 ++--
>  security/security.c                   |  8 ++++----
>  security/selinux/hooks.c              |  6 +++---
>  security/smack/smack_lsm.c            |  6 +++---
>  15 files changed, 43 insertions(+), 43 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com> (LSM, SELinux)

--
paul-moore.com
