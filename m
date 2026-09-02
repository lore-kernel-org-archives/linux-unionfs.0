Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BA83939D7
	for <linux-unionfs@vger.kernel.org>; Wed,  2 Sep 2026 19:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377708; cv=none; b=dOlkhdDtvNSh3I4GOjqCUoxjJTdFpthQjvm8aNlsGPQ+lFoZlpFXGxaQ/hPfAKrZS1dBOTigdg5LgMp6YDxGIjgsuDIEEpo8LiWf7dfS1Ubk6p8/Pjh1KFCHhMqrkMLx9aoahmqIAwyFX+9f8ABGsNZY58iVnV7WR9LKcJLhVik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377708; c=relaxed/simple;
	bh=3WGPUky1hmwDKOIR30PGoglOqPg/CfPHhhz1D/WGWTI=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=ioLXWIo3txij7d6xF272/bQN0H8QPamPyshFrBafAki137sForbpS2+kFQ9CtuE2jIp6R5oJPjT4cmMVK8QV46dt1U1gZLRzTX4a8jhLKKVCqfYgllazA1NxJyRBaj5jeyrk6vaeMJ29GcwyFLVghEMqiG464PmviGm6pz93dbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=dA1yL4xF; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="dA1yL4xF"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5302b692c8eso13742811cf.2
        for <linux-unionfs@vger.kernel.org>; Wed, 02 Sep 2026 12:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1788377689; x=1788982489; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tTllqewIXAY5+sR//IBZWAZfUENL/NuhQCFU0zl+dm8=;
        b=dA1yL4xFmI/xLm4gRSWgFben1ST4myVImRVF3JDQcxKkV0fYD1Ntg9aKbmMS+Z+l78
         1/PWPbsjSZySmLHZideqKf+2aZzOLMAX9z2/84wXgSVlWbAm5hXDMv9KcEjc/puDweL3
         S6hUENsBnMQqsWYW9wDYNaFFFD1w8xhepjmDHisqycyUmz76aqSpxZvHM4OwoAAiQvlw
         62c4LWA0DWUYE6qqfOJzANDT6279+eDBPO0QC5/KDtprAIrbEoN2zG0aTCWDkC8nh72q
         TxsRBcE/AJeHtQGYCav2Fm3C30T4flhV5XQnCvzHynsxo+HzPMRVXjx9/tNF0MFsGTZa
         6OEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377689; x=1788982489;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tTllqewIXAY5+sR//IBZWAZfUENL/NuhQCFU0zl+dm8=;
        b=aQQgpjsyDncdi66Si79CpflYZK3Q4qjK/BHIQEFubqL5lRgvcDDfqrl8cXM4neFUuu
         4CF7EpFV//jx0GGpCTxn85RXOSdEMwWrb3iHRbaBS8xthjF/jsDgUwIaPUD6ay72IC5g
         5T+j7YkVxod5mCcSFEMUuXyfXYspHXAX6UDle5wCO2OaPhJQqziGPcxngVdr7pMtM50+
         NdcJZn9XRcmfFZO962j2/7gRVwNQkX/aScgPiPBv1U3Eek9iXkBYrQrdBTPQLDYbUN1c
         twqp6zObAiO+OXpbeOX9N3vM+46fHc1MxqH1X010C2h7iFAG5lHMUw6ktk+Z80Uk+G3/
         4RMw==
X-Forwarded-Encrypted: i=1; AKwUvBzFz5Li5vfDmYIEGPVww5Gfo02tTZfEY5mxu7NZewf6vzHYGaUt1B0v2j2I37zMkjSe2Oxt+PaTgqr2WveJ@vger.kernel.org
X-Gm-Message-State: AFuF++kD4k+E/fVtOz9wr/TCnXmtC5Qub3M9T+oQQMq9itzG1AFK7Mzw
	+va/X2DRvw5aypgNGYkSYjvSzr1leaQZNyp/9cah+nz390dfliV0qiS4RT+p0/ArVA==
X-Gm-Gg: AYBFou36ULUba6TxZ/uuuH7JTYb/qan2uJ2mpQRhtZKYIpu1jA7kJCz3e4kJcZpT9XQ
	GCv24n1iTHaPhMR77JwTF2pu0MoqCKK2t+nv07nnUMqpGB1/B9Dbn1irWgU4JFNzGk7pmhD6oDv
	V5Jf2A7dij5IWyk9VLsm+p30a/PakUJyM6cYuk5MEkvtUdSMiZvhOk2quT2mMahX3mM0JQ8n1cQ
	lxF1etud5XPoDriyo6WMJ2TJV0oewTj2oPOj0vE2xkfg8UCL2Wsn7a2G3JKyKE+YHFqn2OUtvLf
	0vnTgYfYEWC5VSLHiD/0iVVoLueLtxnojr7lwrfpxnMdQocbgZCpa92Duo4lySHV49tsIhBxbMM
	Xj3jR9ChZuIE1UivllNuawrpxtZy80/JUX+6faakZf/OMn7nfvTqsygMsjf0cco81r5k/1YdZBK
	ByP1W45/bbhFETONMTEpsVXHo/auexoBRFDtNrGfdtdEzKwokvPtwNMywUUWgaRefseEiLYewI6
	ipZSslwmfbx+t60phdLbygI4QREyyCHgQ==
X-Received: by 2002:a05:622a:1f8d:b0:51b:f25c:2896 with SMTP id d75a77b69052e-53036bfdbebmr93564831cf.11.1788377688931;
        Wed, 02 Sep 2026 12:34:48 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53033252530sm25672391cf.28.2026.09.02.12.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:34:48 -0700 (PDT)
Date: Wed, 02 Sep 2026 15:34:47 -0400
Message-ID: <4bcb6be827e73a667592e7110ba78682@paul-moore.com>
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
Subject: Re: [PATCH 12/27] fs: port ->permission() to pass const mnt_idmap
References: <20260901-work-idmap-const-v1-12-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-12-54ccd48e100b@kernel.org>

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
>  Documentation/filesystems/locking.rst |  2 +-
>  Documentation/filesystems/vfs.rst     |  2 +-
>  fs/afs/internal.h                     |  2 +-
>  fs/afs/security.c                     |  2 +-
>  fs/attr.c                             |  2 +-
>  fs/autofs/root.c                      |  4 ++--
>  fs/bad_inode.c                        |  2 +-
>  fs/btrfs/inode.c                      |  2 +-
>  fs/btrfs/ioctl.c                      |  2 +-
>  fs/ceph/inode.c                       |  2 +-
>  fs/ceph/super.h                       |  2 +-
>  fs/coda/coda_linux.h                  |  2 +-
>  fs/coda/dir.c                         |  2 +-
>  fs/coda/pioctl.c                      |  4 ++--
>  fs/ecryptfs/inode.c                   |  2 +-
>  fs/failfs.c                           |  2 +-
>  fs/fuse/dir.c                         |  2 +-
>  fs/gfs2/inode.c                       |  2 +-
>  fs/gfs2/inode.h                       |  2 +-
>  fs/hostfs/hostfs_kern.c               |  2 +-
>  fs/internal.h                         |  2 +-
>  fs/kernfs/inode.c                     |  2 +-
>  fs/kernfs/kernfs-internal.h           |  2 +-
>  fs/namei.c                            | 22 +++++++++++-----------
>  fs/nfs/dir.c                          |  2 +-
>  fs/nilfs2/inode.c                     |  2 +-
>  fs/nilfs2/nilfs.h                     |  2 +-
>  fs/ocfs2/file.c                       |  2 +-
>  fs/ocfs2/file.h                       |  2 +-
>  fs/orangefs/inode.c                   |  2 +-
>  fs/orangefs/orangefs-kernel.h         |  2 +-
>  fs/overlayfs/inode.c                  |  2 +-
>  fs/overlayfs/overlayfs.h              |  2 +-
>  fs/proc/base.c                        |  4 ++--
>  fs/proc/fd.c                          |  4 ++--
>  fs/proc/fd.h                          |  2 +-
>  fs/proc/proc_sysctl.c                 |  2 +-
>  fs/smb/client/cifsfs.c                |  2 +-
>  fs/smb/server/vfs.c                   |  2 +-
>  fs/smb/server/vfs.h                   |  2 +-
>  fs/tracefs/inode.c                    |  2 +-
>  include/linux/fs.h                    |  8 ++++----
>  include/linux/nfs_fs.h                |  2 +-
>  security/selinux/selinuxfs.c          |  2 +-
>  44 files changed, 61 insertions(+), 61 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com> (SELinux)

--
paul-moore.com
