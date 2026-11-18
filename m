Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795019650;
	b=JOweqroFKbHeb8k4j+qQpXBebfGESme1vgn6Ln3iBZs5SuQZsqaFDgUs+2cqd88Ic+mh
	 898oOx2jitXNM73zE7ERGnTND/1L6LyfdtCLrxAwr6THDOrXkQwrLLjc5I6hW+Z4HqmDG
	 jLVl8vPyj7tFnaJ1fZr88SIzs0y/CMRxQXP/LJ47Ky+y1hsHcbOf+gYGLDbQoOFyx7R+c
	 PoEnZRV99lJdW5ZvDVUsxfPsXGvfev1mYiDqM0kVjRua3gTASNje+cteH6lhQQJ5sKzV8
	 IFItWTQEFDySPVZl40CO0WJZjZk6dTPyegtxN7DRu5uRvl+2LRf/eOhNLerOUFShKOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019650;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=N6HX3LXsa4mhOdLfCTbxFIXTc5FHr4ZNGQBe4lysFkI=;
	b=zrRJZWLMTNgYBOOqYo6LhQvGRbb0igd11EVFOIXaE41IAzTyBOsV1lsmua0MsLg132cb
	 ptHxiP1qmYvt2t40zVrwmvMWl9km+dqRoQe3N42RnUuhq9OnuIVHrUTsdfiVhob/w0aRl
	 ndWnsq4GJ3s1bNwLzPydZt5Qt79iLzG99TXNb3fo9CX8bkKtcDMct+nPWzxMs2ZSGj1aA
	 1CaGelbi4cQVKW+Ok1AGi6ERFKQSyfpoNYwtwNClMDnv6RjyOT9VJZAHOn5oV5sDSbi3p
	 BIvaiXCahMmcrLk0QtWyav4BnlJW1aCIbY33GZQfTwAoRKcN5a4DPV079a+5fDylerQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=edDD+3HN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D35606A335
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 16:34:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29D35606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=edDD+3HN
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b88bc47e23so1538666a12.2
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 08:34:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795019647; cv=none;
        d=google.com; s=arc-20260327;
        b=ejrLNvlBBegi/xMNHF/GAtAQX4yZDKis6oM+FeEflxnUSDCCiEOAuoVj/teB+CcR+x
         ppIq+iWCcutfPdUbgNjAFzuMGj4F5VhJlED0uygGfT7zlHXXjuuyiE5RomTtLpJg4eak
         ZnroB6RYBnnRZDZ61tiOtMggtHlSUCoyhB2LhREoOrPDXiF82hCP8mZhh45QAgLuZuwv
         +Sda52sHbR6GBm4QRaYvg+fYHf/5fSX5dkhtkVQvbKqS3GAZsBE5PwcUAirhtpH4BrUD
         c/r5irSMRQG1tIYNNbaycMJN+73ZssUwUDDUeah7HYLfIBuzxKC290G/FPWhfMYd23jX
         HyqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N6HX3LXsa4mhOdLfCTbxFIXTc5FHr4ZNGQBe4lysFkI=;
        fh=QvzmKQBsZnJwkPM+juC5Cdsr40advHo51959z0Mxr4s=;
        b=TL2mjnozmeTBaNQ6vZyXmIBgDFiSMErTUGy6Z9unTdmQw3UvpwuZ4ZAV7JlA/z9nRF
         cR7SA7TfxVzJlMzzJNQTIP4NE54tF4ZEBHxXum35MH0M5jT6G1y+AjB7QBueWgNsN3Iu
         DQ7XKblCsik/WHxMn64w3vQq5nqQGytqgHGfQ4KjxfDhPHDGQm6Zt6BvytdGYv8w3Boc
         nG1QHguzl2OI4HfVjxNoHDmhN6/hB/8rbebs0Szkpx+IU5YcNZeZl/nRlS83Mjxys9JA
         eahLXGjjwm6FvaYtNySxlGX7fuwvjV2eZDZTgCka2Qsg5qyFJ4CCfF50unWQBHXl9ngb
         v9hQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795019647; x=1795624447; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N6HX3LXsa4mhOdLfCTbxFIXTc5FHr4ZNGQBe4lysFkI=;
        b=edDD+3HN3eSgxPe1vLYMsZA9DrM5whP4dDb6n+MqzrRN7ZqOif36k7v2vBh/SURUzl
         h45+n5470/Z1jV0YhRHqQGF8vCKxYixCoW96DLDba2renWvH3vOO+WEsdwtqHwRM2bly
         rGjZ500zdbUecLbTi7KBVdGOT58lTeKB0SbBCg2Gdmp0szBqM7jDK7Qc4QUQ+SW/KHyS
         pYbjN2WhdxX24l9f2g61LHIlBuowbE2fzG2sUPimi1+EANR3GhB9jK35eA9Dkb3JL+D+
         g3ufmoSo9e5O/Zu/uPruXbqCKquDzeHhTWiwpTLCOWYzi5kI5gkCjFHqRHJUjE+314hb
         q1EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795019647; x=1795624447;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N6HX3LXsa4mhOdLfCTbxFIXTc5FHr4ZNGQBe4lysFkI=;
        b=AzEf+L6tVeEy+EsdNDXAi/0yAj4lINCq+Jps//TTVNsvPdU00lppxzmvOMsxVdRlEx
         MESrAawSt/wA9Z4HXGn5l7AKmJvdAjhOi52VJk5l4F4GORLgKQmkZwYYQDPWqf8MXV9+
         HSMYWVW1SHVkeA+nP3ZjSvomIlsrsoL4+6GA4ksjGbC2lP8Pdb9EmYhv7VUYwRAIdENY
         6GuI/G6p5xiQhmTEcjVwZFu5oC2lEv2AzmFTmBPYaZgYjqpiedI9UepkzWPdw3ntPorb
         CpI9kocmUfz6Wuex8IVx0XKPuG3Ld3jyGsjcmXl3Ab5PZ3RgdwGh0uVpSD1UxYpJRw9C
         zeUw==
X-Forwarded-Encrypted: i=1; AL+hErH6K/RWY/6Uvs5hhSIvocGBkgHJAX3/mVHITPCIa6lPrw3RSAHqIPUn7OGO+hFodZf5pROKByqhYq0a4B9Z@vger.kernel.org
X-Gm-Message-State: APuU4Z8dlwJYf7n5WmGGiUQHWM75+YRYjNSHhbfZg+GWluAKtNF1yUFS
	V7nu+E3ubeI4zds/TWS+/gpzw019Tjm6Nzz0DYVyaeVFkFIa2V7wk9KCdNen1DHMsqA3RLOZtRX
	+NMVpo7UUjHBG9uWJ1yXM8u6e5AYbeBI=
X-Gm-Gg: AYBFou1TjzCeyFBnR9vRZlaWnALVduzpHELLeIybEHks8v+zEb0aM7nTfxs+nxz9bTn
	gWTQ5t11zJpDK+7TPqMdXKaqB8GMMD/0ruc/IXu9DwUJmWc7e3dSZ4Yy2ZBUgcVBVoY1KbvwU2t
	u+yoIsuK+I4dMsZ/QAeOtzBiB+3aJ5BmRPa3UE0B5Sv6S0Cul3QAIwKa9DkVWBZYj0UYQe/+qUO
	mH2obDPs6/N0AAFbQnJ4KTdzSkiZ+4CMCXsvCjDFIkfKMAUCV7/RVWvNe9lhRRBzZ/+vlSQSC0X
	hjzMuM8jTOE6c0gOQqpQ0+vK+QORVl4VhSohKzsBwFUY8PtnN3am7Y6Rc00AbrZzzMH4AtKl1rb
	n0vFfEADkh0nRcjtIGBRPMujQw0DRGsFJLrqpHChbzFeFVYu70nvutw286R+0GUR62X7A7+k=
X-Received: by 2002:a05:6402:450e:b0:6b4:73e6:dc9d with SMTP id
 4fb4d7f45d1cf-6b887f1fff8mr2542347a12.41.1795019647204; Wed, 18 Nov 2026
 08:34:07 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118123105.1247627-1-amir73il@gmail.com> <179500653692.684213.4730864102080566101.b4-review@b4>
In-Reply-To: <179500653692.684213.4730864102080566101.b4-review@b4>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 17:33:55 +0100
X-Gm-Features: AclHuK-POwvPU_DJejkPcXzGEWdSEeV7ICPQ8L3Z6niqB3lgCgZbU0XeQWMehQA
Message-ID: <CAOQ4uxjHwtZEHu9xMM6zg9niSgNdLXhAu65jA8Ai_SKVg-W2nw@mail.gmail.com>
Subject: Re: [PATCH v1] fs: add ->f_real() file operation
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, Ding Feng <dingf3ng@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 1:55=E2=80=AFPM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> > sync_file_range(2) and cachestat(2) operate on file->f_mapping.  For a
> > file on a stacking filesystem, such as overlayfs, the data and its page
> > cache are in the real (backing) file, so on a stacked file
> > sync_file_range() writes back nothing and cachestat() reports nothing.
> >
> > Add a ->f_real() file operation, modelled after ->d_real(), and a
> > file_real() helper in backing-file.h that returns the backing file
> > holding the data of a stacked file, or the file itself.  file_real() is
> > a no-op without CONFIG_FS_STACK; otherwise its slow path in
> > fs/backing-file.c calls ->f_real() and verifies that it returned a
> > backing file.  The real file is owned by the stacked file, so it is
> > valid for as long as the caller holds the stacked file.
> >
> > file_real() is only meant for inspecting and writing back the page cach=
e
> > of the data.  Operations that need the credentials or permission checks
> > of the stacking filesystem need a dedicated file operation, like
> > ->fadvise().
> >
> > Use file_real() in sync_file_range() (also used by io_uring) and in
> > cachestat(), and implement ->f_real() for overlayfs.
>
> Approach looks good.
>
> Would you mind taking the cachestat selftest patch together with it:
> https://lore.kernel.org/linux-fsdevel/20260623111533.2285005-4-ptikhomiro=
v@virtuozzo.com/
>
> I will test it on your patch and update with results.
>

Since you found a bug, do you mind adding the nested ovl test case
as well as lower file test case and re-post your test?

Merging your test is independent of merging my fix, but Christian
can take them together when you have approved both work.

> >
> > Tested-by: Ding Feng <dingf3ng@gmail.com>
> > Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> > Link: https://lore.kernel.org/r/20261118040056.6543-1-dingf3ng@gmail.co=
m/
> > Link: https://lore.kernel.org/r/20260623111533.2285005-1-ptikhomirov@vi=
rtuozzo.com/
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >
> > diff --git a/Documentation/filesystems/locking.rst b/Documentation/file=
systems/locking.rst
> > index f7363ad770c76..db9ba2a8c13e7 100644
> > --- a/Documentation/filesystems/locking.rst
> > +++ b/Documentation/filesystems/locking.rst
> > @@ -485,6 +485,7 @@ file_operations
> >                       struct file *file_out, loff_t pos_out,
> >                       loff_t len, unsigned int remap_flags);
> >       int (*fadvise)(struct file *, loff_t, loff_t, int);
> > +     struct file *(*f_real)(const struct file *);
> >
> >  locking rules:
> >       All may block.
> > diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesyst=
ems/vfs.rst
> > index 1824462a43711..e4ce15545244b 100644
> > --- a/Documentation/filesystems/vfs.rst
> > +++ b/Documentation/filesystems/vfs.rst
> > @@ -1038,6 +1038,7 @@ This describes how the VFS can manipulate an open=
 file.  As of kernel
> >                                          struct file *file_out, loff_t =
pos_out,
> >                                          loff_t len, unsigned int remap=
_flags);
> >               int (*fadvise)(struct file *, loff_t, loff_t, int);
> > +             struct file *(*f_real)(const struct file *);
> >               int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned in=
t issue_flags);
> >               int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_=
comp_batch *,
> >                                       unsigned int poll_flags);
> > @@ -1162,6 +1163,22 @@ otherwise noted.
> >  ``fadvise``
> >       possibly called by the fadvise64() system call.
> >
> > +``f_real``
> > +     stacking filesystems (e.g. overlayfs) whose file data is accessed
> > +     through a backing file implement this method to return that backi=
ng
> > +     file.  It is called through file_real() by system calls that oper=
ate
> > +     on the page cache of the data, such as sync_file_range(2) and
> > +     cachestat(2).
> > +
> > +     The returned file must be a backing file (FMODE_BACKING) or the f=
ile
> > +     itself.  It is owned by the file and must remain valid for as lon=
g
> > +     as the caller holds a reference to the file.
> > +
> > +     The returned file is only used to inspect and write back the page
> > +     cache of the data.  Operations that need the credentials or the
> > +     permission checks of the stacking filesystem need a dedicated fil=
e
> > +     operation (e.g. ``fadvise``).
> > +
> >  ``mmap_prepare``
> >       Called by the mmap(2) system call. Allows a VFS to set up a
> >       file-backed memory mapping, most notably establishing relevant
> > diff --git a/fs/backing-file.c b/fs/backing-file.c
> > index c601b27f0fd35..1e0e85515b4c7 100644
> > --- a/fs/backing-file.c
> > +++ b/fs/backing-file.c
> > @@ -102,6 +102,18 @@ struct file *backing_tmpfile_open(const struct fil=
e *user_file, int flags,
> >  }
> >  EXPORT_SYMBOL(backing_tmpfile_open);
> >
> > +/* Slow path of file_real() for a file with ->f_real() */
> > +struct file *__file_real(struct file *file)
> > +{
> > +     struct file *real_file =3D file->f_op->f_real(file);
> > +
> > +     if (!IS_ERR(real_file) && real_file !=3D file &&
> > +         WARN_ON_ONCE(!(real_file->f_mode & FMODE_BACKING)))
> > +             return ERR_PTR(-EIO);
> > +
> > +     return real_file;
>
> This will go one level only AFAICS and in case of nested overlay we would=
 not get to
> the real file.

Good catch! but the bug is not here it is in ovl_f_real()
Please test with

 static struct file *ovl_f_real(const struct file *file)
 {
-       return ovl_real_file(file);
+       struct file *real_file =3D ovl_real_file(file);
+
+       if (IS_ERR(real_file))
+               return real_file;
+
+       /* Handle recursion into stacked lower fs */
+       return file_real(real_file);
 }

When you have tested this please report back and I will post v2.

Thanks,
Amir.
