Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944B8171C9
	for <linux-unionfs@vger.kernel.org>; Mon, 29 Apr 2024 09:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714383708; cv=none; b=CJibhaTGFPZEI1YiMlHPCBups/MfYQQ+HRSSBjKcAqStb3YLFX4r0BnwoHYE38p9rJerU1oG6AklxwniO2t2qp75PPZmxyBo5q9R9VXTH9IXnsnEIvMx78h4szx2DZznrVKznJ9RB8d3zSqqAbcFJgrnG/yov7CzsUVVpWSQh1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714383708; c=relaxed/simple;
	bh=7xAWea8cioriAeYwM8ij/w7ZcsuSDYoHl8WaxNgp9Lk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ri41D8Bf75WEJJuZPjlrhD8Wyvw+X8daNgbhBrJ/t346WnFZDez2LxS4RzUfuDA5EBhH9vw0sJAWnPvCGWNP0xjEhZEmhvcIqFpUN5fRJxYaf/0RMvCh4YyA9LC0KQfFeNKQESQ/jsrwGT2o10S4x3cy62Cn6XLpko3q2BibNKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=bGmN/4Au; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="bGmN/4Au"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a5544fd07easo552913166b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 29 Apr 2024 02:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1714383704; x=1714988504; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KW3b7ICejyiea4orM3gLgyXEngHryT3qr27lnHqKhVw=;
        b=bGmN/4AuBxwOFhj41TaeujswCargDORzaHj3xvrPAg7M5IiNKn5giedtZ7lcT5kDpl
         3Hv9s3OcHKLmx18S+ShZppZ5IOjod0ozYfXIQY4iwDyTiiH97iG+G2Ya4Lb3ELXF+xq1
         O8bw8VwvIFGQdeEP+5AMJBaD4wVkXcIKvrBrY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714383704; x=1714988504;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KW3b7ICejyiea4orM3gLgyXEngHryT3qr27lnHqKhVw=;
        b=Q1GPF0nt+BzIOFF7JTVOuszwS2jum+UCGiC44QCSLpZD5DXfCoeqIebqOIjds0vXl1
         nxRFXGZuv5LtFNqAAoEg+HaTVVdHk4I0fXUtvzU5ZH3x9iBL+KRx6Ler4gBB2hoqUbne
         UV6yOHIdDocgTdCDzFRuqpcsUvDOtDFr/cEhXMDQFZ+QwVFd5QkOPWCkJv5un2tXvf1J
         IdE5ihdtHz7axahq84xgRIq6nslaVtgwwM0XRT6CJJp+lJtQ7Y9FaGGq4slLWvDPOUfd
         VZF8bTqivIi34ies5Ck1dZ1R5vEpv0P5m49C2oBRHa15AQbwsCeHpcweyrzbydysk4QM
         umFA==
X-Forwarded-Encrypted: i=1; AJvYcCX5Em43zlXJBj0zHCh1mpr1hlKYsxaQqSc6U5gXMY8DvkOClhtm/hVd+2u5IjM8vDaaE+ddiyZA+T8mtVW/8tVQVslL4rikfvpdX++Fng==
X-Gm-Message-State: AOJu0YxusPYvgqMwIQexow1L7hKdwZRL3otsyOXA/6wZDgwwYLpjMXPd
	AQnkCuioTxaYhIzyNPVRvBwAbVOKPsut7dEHj95y2jpiBCv3XI0nH5M67JeR3ge20kI/Axg+TH5
	ZkTXjUOW3WALIdoNj5/Pg2nYcJcT7zlfk88Hrkg==
X-Google-Smtp-Source: AGHT+IH60wIgzLEx+kUxMnW7BqXpHPHOXYGnlvC/TyVLBhgkxx37j7maA7xaGaYE53DqHYkezKYhWHcR1UJQo7CQPk4=
X-Received: by 2002:a17:907:1b25:b0:a58:bcad:47c0 with SMTP id
 mp37-20020a1709071b2500b00a58bcad47c0mr7842584ejc.47.1714383703403; Mon, 29
 Apr 2024 02:41:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240425101556.573616-1-mszeredi@redhat.com> <CAOQ4uxgD3tTNKScRPD4r+ePuGkS5s2X2A3chMA1MXbfz-_P5PA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgD3tTNKScRPD4r+ePuGkS5s2X2A3chMA1MXbfz-_P5PA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 29 Apr 2024 11:41:31 +0200
Message-ID: <CAJfpegvQs+sT0AE64o+=D8b0q4a9YU7PEuGV+kPfejVAP0+a4A@mail.gmail.com>
Subject: Re: [PATCH] ovl: implement tmpfile
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 27 Apr 2024 at 13:58, Amir Goldstein <amir73il@gmail.com> wrote:

> There are some tests in src/vfs/vfstest that run sgid tests
> with O_TMPFILE if it is supported.
> I identified generic/696 and generic/697, but only the latter
> currently runs on overlayfs.

Yes, I ran full xfstests, but now I also verified that they do use
O_TMPFILE on overlayfs and it works.

The only one that didn't run from these was:

generic/509       [not run] require /scratch to be valid block disk

> > +       path_get(user_path);
> > +       *backing_file_user_path(f) = *user_path;
> > +       error = vfs_tmpfile(real_idmap, real_parentpath, f, mode);
>
> We do not have a custom idmap in other backing_file helpers
> don't see why we need real_idmap in this helper.
> I think that should be:
> mnt_idmap(real_parentpath.mnt)

Yes.

> > +       realfile = backing_tmpfile_open(&file->f_path, flags,
> > +                                       &nop_mnt_idmap, &realparentpath, mode,
> > +                                       current_cred());
>
> Using &nop_mnt_idmap here is not only unneeded but also looks wrong.

Yep, no need to pass idmap down this helper, since it can be extracted
form realparentpath.

> Any reason not to reuse ovl_instantiate() to avoid duplicating some
> of the subtlety? for example:
>
> +       /* ovl_instantiate() consumes the .upperdentry reference on success */
> +       dget(realfile->f_path.dentry)
> +       err = ovl_instantiate(dentry, inode, realfile->f_path.dentry, 0, 1);
> +       if (err)
> +               goto out_err;
>
> [...]
>
>  static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
> -                          struct dentry *newdentry, bool hardlink)
> +                          struct dentry *newdentry, bool hardlink,
> bool tmpfile)
>  {
>         struct ovl_inode_params oip = {
>                 .upperdentry = newdentry,
> @@ -295,6 +295,9 @@ static int ovl_instantiate(struct dentry *dentry,
> struct inode *inode,
>                 inc_nlink(inode);
>         }
>
> +       if (tmpfile)
> +               d_mark_tmpfile(dentry);
> +
>         d_instantiate(dentry, inode);
>

Okay, makes sense.


> > +static int ovl_create_tmpfile(struct file *file, struct dentry *dentry,
> > +                             struct inode *inode, umode_t mode)
> > +{
> > +       int err;
> > +       const struct cred *old_cred;
> > +       struct cred *override_cred;
> > +
> > +       err = ovl_copy_up(dentry->d_parent);
> > +       if (err)
> > +               return err;
> > +
> > +       old_cred = ovl_override_creds(dentry->d_sb);
> > +
> > +       err = -ENOMEM;
> > +       override_cred = prepare_creds();
> > +       if (override_cred) {
> > +               override_cred->fsuid = inode->i_uid;
> > +               override_cred->fsgid = inode->i_gid;
> > +               err = security_dentry_create_files_as(dentry, mode,
> > +                                                     &dentry->d_name, old_cred,
> > +                                                     override_cred);
> > +               if (err) {
> > +                       put_cred(override_cred);
> > +                       goto out_revert_creds;
> > +               }
> > +               put_cred(override_creds(override_cred));
> > +               put_cred(override_cred);
> > +
> > +               err = ovl_create_upper_tmpfile(file, dentry, inode, mode);
> > +       }
> > +out_revert_creds:
> > +       revert_creds(old_cred);
> > +       return err;
> > +}
>
> This also shouts unneeded and subtle code duplication to me:
>
>  static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
> -                             struct ovl_cattr *attr, bool origin)
> +                             struct ovl_cattr *attr, bool origin,
> +                             struct file *tmpfile)
>  {
>         int err;
>         const struct cred *old_cred;
> @@ -602,7 +606,9 @@ static int ovl_create_or_link(struct dentry
> *dentry, struct inode *inode,
>                 put_cred(override_cred);
>         }
>
> -       if (!ovl_dentry_is_whiteout(dentry))
> +       if (tmpfile)
> +               err = ovl_create_upper_tmpfile(tmpfile, dentry, inode,
> attr->mode);
> +       else if (!ovl_dentry_is_whiteout(dentry))
>                 err = ovl_create_upper(dentry, inode, attr);
>         else
>                 err = ovl_create_over_whiteout(dentry, inode, attr);


Instead I opted to extract the creds preparation into a separate helper.

> > +       /* inode reference was transferred to dentry */
> > +       inode = NULL;
> > +       err = finish_open(file, dentry, ovl_dummy_open);
> > +put_realfile:
> > +       if (!(file->f_mode & FMODE_OPENED))
> > +               fput(file->private_data);
>
> This cleanup bit is very subtle and hard for me to review.
> I wonder if there is a way to improve this subtlety?

The reason I did it this way is because fput() code checks
FMODE_OPENED and calls ->release() only if it's set.  So essentially
it's an indication whether the VFS will initiate the cleanup or we
need to do that ourselves.

> Would it be possible to write this cleanup as:
> +       if (err && file->private_data)
> +               fput(file->private_data);
>
> With a comment explaining where file->private_data is set?

If you look at do_dentry_open() there's an error condition after
setting FMODE_OPENED, that would result in the above being wrong.  In
fact that error condition cannot happen in overlayfs, due to aops
being set just for this reason.  So checking the error works in our
case, but I think that's more subtle than the FMODE_OPENED check.  A
comment would make sense, though.

>
> Overall, I did not find any bugs, but I am hoping that the code could be
> a bit easier to review and maintain.

Thanks for the review, will post a new version shortly.

Thanks,
Miklos
