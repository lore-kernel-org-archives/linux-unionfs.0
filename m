Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CCD372675
	for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2026 21:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774300015; cv=pass; b=DVkSYq9ISh3OQLArtg+cX3YVGV/xf9DEY6pe/MpJt5K4+7EH+oRiW0BuHc9wcltj0tbqAcfWWkttCCueEiBtSmVp0NFJJzA5HYZ4ttyn2fG6gchfqJWkLomit0dq9dhT7qMyKqFhY9+p0jnOVWSVzXGvsbghiCig6QGaGoCw5Ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774300015; c=relaxed/simple;
	bh=lj1WSksNK02aO4n5dob09BxWp5H6I1TYco9D2RasOo4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m2R+22XHJsuBwZhi71CLMKzPU18ekUznw1xuQ+9+5SzAVdQsal6rJcYSnM1thUcSksLhUGs06emJ7qSdf3R2JU3/k8bByeuRvzLdekEAPyCJM8aRUUs+h4CrStCGy171961NYAvxi+LrU6lKQmzi5rGRrGjJaJc+fzkl+QRkobQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=QBtcS8Hv; arc=pass smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="QBtcS8Hv"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82bae83318bso1639989b3a.2
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2026 14:06:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774300012; cv=none;
        d=google.com; s=arc-20240605;
        b=DAASSRAJc0yMTdpEa9yjucAkEffNDRqrasQP5aEdWSwijL5PPC6oS5/f/62oCaI3j8
         Qy6GxyVOdQXUDj47NLAtlRQyq1YTMEAQo+0K3v+G53EpSVs316hZ0lpooCw1+tGn/T9R
         CqCVafPdognu+KXzkYFcpAT1WlOeKYjoJ4+q8+ub5khLvv8JWmx0epUbTBbIrXk1oMNZ
         LS23p7ti98blFpzcwjrxbYg5d+fPP8Q8OD4Lrt37qWT9P5vy9ZbSlRJng6oRaO0LOgU3
         nsOg5NPdFd57mDb3NbmOMy91EVSMc3L4cSp5iVd2XCVtRKcwT3k7Fc3sBR5F0MhNok3u
         PW0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NjsO6wgNY9CZeU5uk59dSPA1jA8p7uootZu2+ykxgC4=;
        fh=5tlsi0QvxAs9MkEz1MzAXPT5bCQ3j3mFTXGnXTUIWVs=;
        b=igbisVRWl3wz0ZONORAxYrQzHEzHo62t5puGbJZHYE9I8qrNXBGP2XQX1/vwgUdmQr
         3Z0oOZjn8NTKUMIb0AfhVf00fcIJiOkKfb+TwfUUEcgK6lwtxccyZhG+8z/9VmOG/Vno
         veOzmHu9PKnoiFnFWGEGcuQXXc+3Nkg5IWr4vCtKr/LY1ymFU5HURKj/OJWKzU4y3VIR
         pV0AtMoPtNv7DfOIZG/M8ZxBcTmqAXOghbk2Q+LHjGQC+F+xSsw5DM5YJnzsrAhLCAEO
         AMpwraNdriSHX/lJuvK6BmD0iTqc1ifoqyEteh4Klb1jpF5gXmytoifrJS5UIuKy3wJb
         BpqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1774300012; x=1774904812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NjsO6wgNY9CZeU5uk59dSPA1jA8p7uootZu2+ykxgC4=;
        b=QBtcS8HvpXO9IbViIwHmSUEd1cdHjK9S4SFD+KrQZ8bhDITcqbTe3aRVCdBgTe2A3n
         yPEMyrAXW1HDf/yOqvfhmV0UV6nsguDlNnwsiu12fdLFTcyQQDeLoE4ppjSujK/vYbur
         6Vh4bHjxQOGvJNvQcmIiGYefdfM6j1bAXms/E3+nKb3ABshNU1uhN6kg/vVgaD/GcP3E
         akpfjZl48gVESxxOIaGcrKwYKHddzWZAykOpSpFzHdXM1Jum5FB6rgUjQu+UPGDg6Q7/
         V9guohjp86bKIOaGeatTnM/vNT8vs82Ng13J8AmyBqJbn+u0bMDJq0vLUZtTY+smpY03
         GnYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774300012; x=1774904812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NjsO6wgNY9CZeU5uk59dSPA1jA8p7uootZu2+ykxgC4=;
        b=qyIKHHWLi0CzmMc9Ylm+EswUq/Mjc16yX3HExKzTOyH6fLi6LqW3A6BpaVb9JTn0dv
         +w53ehRj7nu1p4VmRT0c+2SapCMkULjI9Jdljl16klXXofX+n7QKfXBZUxyBPWo4UU2n
         Phb3Fv0zurUjSLiY4wQHn29IyKX3I4COyt/zCqwtnuU6oGhNFE25J7rvxFXPIHzi3+LI
         9Zw0jUgytEF48Lcn40Cy0koRiOgQSads/gG9oI5ih4+mC1YszHrI5X/6DvxOSIozHm9x
         07LOIbbXpFsD57IBluT9VpKxbpCcnb/6E+Ss+DIH/cmaLUgLOzc7Shi669m8CKRKjqkH
         bmoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrwWyrWNio5d3cCRK+MAoIK+97/4jtzr483AfJTAPRJ8L7s8V5XM0dfCqCwU4BCr1mNomrt4Xqn4ES/imN@vger.kernel.org
X-Gm-Message-State: AOJu0YzOMhT5ts9NGEvQ3LjKi2SHBMUmgb1UWVcN/q4yfqch5orzyUPj
	eheGouajwFXE4hI+0Y334UDdNwXb+UD22fVofVnxCc33uDHyJ6KD/zACRwxJoQgbJFJFizVgqzd
	uaFGMVg6A6HMThOBP0379bMviGX9HN8kpaTl/ZpW8
X-Gm-Gg: ATEYQzymqxCiJbnL/owuPQ1v6yFA8TeJMxKK895ncYHYoylXW0YjowvF+5nAIMp2jOE
	wSD27UHo1VB8HZLe0VcCymNaeJpXzNwp7orI/HsXQi5E9pnmfbOISYpfRUH50iZ8trOjHAsgBSi
	L5iHCKLbqHnV7u6nxCBtKTirUD8Aye36xxle4O3uAUxfsLRmCDK61IPqyBJzk0qLKqeX/BKrUNx
	5MmcvAiH9fr/0l08epxQXXwKmIiw1U8oZGFv03cBwXX5ztl8iFAzrUYl5oLMAJ4K9fuPpJVe67U
	Pr1l3jA=
X-Received: by 2002:a05:6a20:a124:b0:398:9923:749f with SMTP id
 adf61e73a8af0-39bcea1d2c7mr12205176637.20.1774300012580; Mon, 23 Mar 2026
 14:06:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260323042510.3331778-4-paul@paul-moore.com> <20260323042510.3331778-6-paul@paul-moore.com>
In-Reply-To: <20260323042510.3331778-6-paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 23 Mar 2026 17:06:40 -0400
X-Gm-Features: AaiRm51oMol5rD-3lC5JmUxYQEOgP29lPad5MhWEYDTptj6N_TPcJrob_X8Dy0s
Message-ID: <CAHC9VhQJcuA0VTpGSD0-x+Z5a__SQBiYfwc9zWwLMDa6THfKPw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/2] selinux: fix overlayfs mmap() and mprotect()
 access checks
To: linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org
Cc: Amir Goldstein <amir73il@gmail.com>, Gao Xiang <xiang@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 23, 2026 at 12:25=E2=80=AFAM Paul Moore <paul@paul-moore.com> w=
rote:
>
> The existing SELinux security model for overlayfs is to allow access if
> the current task is able to access the top level file (the "user" file)
> and the mounter's credentials are sufficient to access the lower
> level file (the "backing" file).  Unfortunately, the current code does
> not properly enforce these access controls for both mmap() and mprotect()
> operations on overlayfs filesystems.
>
> This patch makes use of the newly created security_mmap_backing_file()
> LSM hook to provide the missing backing file enforcement for mmap()
> operations, and leverages the backing file API and new LSM blob to
> provide the necessary information to properly enforce the mprotect()
> access controls.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  security/selinux/hooks.c          | 252 ++++++++++++++++++++++--------
>  security/selinux/include/objsec.h |  17 ++
>  2 files changed, 200 insertions(+), 69 deletions(-)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index d8224ea113d1..2a3d524dce24 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1745,6 +1745,60 @@ static inline int file_path_has_perm(const struct =
cred *cred,
>  static int bpf_fd_pass(const struct file *file, u32 sid);
>  #endif
>
> +static int __file_has_perm(bool bf_user_file, const struct cred *cred,
> +                          const struct file *file, u32 av)
> +
> +{
> +       struct common_audit_data ad;
> +       struct inode *inode;
> +       u32 ssid =3D cred_sid(cred);
> +       u32 tsid_fd;
> +       int rc;
> +
> +       if (bf_user_file) {
> +               struct backing_file_security_struct *bfsec;
> +               const struct path *path;
> +
> +               if (WARN_ON(!(file->f_mode & FMODE_BACKING)))
> +                       return -EPERM;

Based on other code paths, we should return -EIO here.  I've updated
the patch, but I'm holding off on posting another version for a day or
so in case anyone else is able to take a look.

> +               bfsec =3D selinux_backing_file(file);
> +               path =3D backing_file_user_path(file);
> +               tsid_fd =3D bfsec->uf_sid;
> +               inode =3D d_inode(path->dentry);
> +
> +               ad.type =3D LSM_AUDIT_DATA_PATH;
> +               ad.u.path =3D *path;
> +       } else {
> +               struct file_security_struct *fsec =3D selinux_file(file);
> +
> +               tsid_fd =3D fsec->sid;
> +               inode =3D file_inode(file);
> +
> +               ad.type =3D LSM_AUDIT_DATA_FILE;
> +               ad.u.file =3D file;
> +       }
> +
> +       if (ssid !=3D tsid_fd) {
> +               rc =3D avc_has_perm(ssid, tsid_fd, SECCLASS_FD, FD__USE, =
&ad);
> +               if (rc)
> +                       return rc;
> +       }
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +       /* regardless of backing vs user file, use the underlying file he=
re */
> +       rc =3D bpf_fd_pass(file, ssid);
> +       if (rc)
> +               return rc;
> +#endif
> +
> +       /* av is zero if only checking access to the descriptor. */
> +       if (av)
> +               return inode_has_perm(cred, inode, av, &ad);
> +
> +       return 0;
> +}

--=20
paul-moore.com
