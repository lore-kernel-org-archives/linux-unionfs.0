Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C51D39E6E9
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Feb 2026 09:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770284251; cv=pass; b=PqxGjoBViQFhaQdAwwwFapw6yVuPoqQKoXRPXp7iVXcjmVEodcj/k8GI8gESb5aLXwTVrKUCSUwr09w/ZorXX9BxVu82MiSOYPd5w/i9OY3vnjChqITdXYKcAIgicJW0o6jLhf20iMbGgPh2Fo+ln5q7G2sdSKRSPhSYvDlo4sk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770284251; c=relaxed/simple;
	bh=O3zjcpb1gIgdrnZIOWkOIcCmTAMhdJCAtczZfkl8Mgo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WAzYR/ZgXqDUhQfl0FcWGaky8U5CYVpZtKdwoWWc0pXwiOqhxQUKA72zFm5xTrEgiS9Z6t0FrhTrjwSpcsqBmHXn+gTRucJ192H+l76+PGFfVcj0nELJ96/zEv4ceKfwKxpJjQSwZQ04l4ksDArzNMn2EdYxI9FzfLjxvniLD/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FjUGTiXw; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FjUGTiXw"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65956402da9so1336261a12.1
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Feb 2026 01:37:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770284250; cv=none;
        d=google.com; s=arc-20240605;
        b=QP1LEBKsjmdVjj3GQYHu6Q0r0WoMiE8ieOUmlbyeaAM+aPXp1C4RgViVQ6BP16ybj1
         kvRrq112zSmgtnc3FUOuHcZhMAkDT8Iuz9dr89+vFlo0Qn+OPfbqH1ep0rW/IzZjdrOP
         FqDgRDAy/4asQYiGtD8Nzbps1MzetI/+x+ePsp8gP+RA6EGIDZRjH0P4msnb3ikbIwpn
         nVihdm0SYAEiRyl+JkiFPcOwWrEygavjRdIgau2bSAkRZEQnIYwjm5bzZMzSj0dcuzAt
         66qXk69jKrO9CKwvHiBFf/D+v0jlfosZRwvituyQlF86sPF4frXSdMnHeb1lHDW6brJT
         Ys/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ts7BIpqOHUIYO1yz8UgL/PwCOZwIbnvcvFeQ/hBIaCk=;
        fh=oNBTSJRl2jE8aJy+3oOF5cOzCZupsV1PuZfGflrqgyk=;
        b=ZOpCgM1WZBchmzbt/HZ5b1dKsMcPf/EwfyKxQK5PzFcGBWmkUJ4A82DRl+Gbz2CKMQ
         WYaiTK/dg2ukQXUrebye1nskeIRy4RzNa+0uN8FHY34Jp8QX6rVjKEteSDUpRn+x3F5y
         heeHQveoK+jg5MSpVeitDUbtMFKNvZ8Om3NIXzu1YN/k8EZVGqTw00Aiii0bhKc0aiaY
         EV8QPOl30AaLFIXK7Jf/U86iT1FzLhAYNBfXWh+z2a1hVWXJUFLHLUbRoeWzoqY67zmm
         c31nsqSFZ5JlV2iQ4gEzV0zoiS80wCj0tHGXaZlabTzDQ+EwCQlJgofk45cKzy9LiR+t
         841w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770284250; x=1770889050; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ts7BIpqOHUIYO1yz8UgL/PwCOZwIbnvcvFeQ/hBIaCk=;
        b=FjUGTiXw2YWjuQ7I+GqvszU9ONy2XE3+0JTAxPXHkvt5eZPZz+J5Ufml3pqOgP8T2L
         rGpjc6btwhogLQMha/Jf6R6/yMMHusEbVvvB9GvauRcrLVSE37m/5NRzEmxkn7UFT56a
         iuPSJZkpndM52iukwsc73xY8GdCH4GozIXR7BrzDyyEcwiI2UfOmNraXaq/qo6qKWX5v
         Js4guz62jAPbbEGBBruoJBw9nESFq2rhHfK5hAw/E3v3AMLBniyg3HEQD/EO70aNkSpl
         fnmqT9r0YmS9KqEzDR/y8yvYgP0e5gBj2781l3djCI2R2Qr30Ey5NTf0YpiUPWKYhCsR
         bKZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770284250; x=1770889050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ts7BIpqOHUIYO1yz8UgL/PwCOZwIbnvcvFeQ/hBIaCk=;
        b=n4jLyKhnYde/SuNkH1DW75A/ZNkqZ5q87MK04XoWHyaORFvgYp4GxJ7nHQ6Rhl6Zy4
         BXNfEz1gjWW1fz43NRKqO27g7UEG7atabI0uKZ9snu39Bq8Yx9ggU9YopUD5Yu9v6lqb
         ZSPjxGTAUAMqwf++ACAeZTBLbUOjYmBsCamSpRZdwsigfEvpzVMFDxIibcBJwXtKN7gQ
         QPG1dbvItmIGFKoBfP0tYVTjRNkj2JNvuXCqgZY9qqyVPCfRPuNB/3c1CGwYtgwO8XXn
         60hwntuE3RSU7oK1s/l1yZ0/RNxMptn0QzDJzGQtu6A2SFvmVvbvAW+S8l4spbod+nwN
         4xAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHfNAh242gY7Y6pJSsUul5AdS54Z52Nk1ENzSBRUzEnNCN10aJ0MRPjY6cCoDgbMe9QYpKYMxayanJR9pW@vger.kernel.org
X-Gm-Message-State: AOJu0YyvMCZAGDGtX9SxJTOO1omsbriiw+osN+DYOjTUmlOJnKEpcVIR
	AZsWeUOLHKPpK5W1++TUhtsWBgz5j/mg8cV8OnDlRm7fW3SWNb2Glci04Ot5CXLjFUKZJBKfYmC
	oSwAKm2XrKR2oJlX6DWFq60KA1z0dvik=
X-Gm-Gg: AZuq6aK3uXpBqqvp5MPJNtj1St58CkpEIZeaJJXR1sOYiZRisiZn4wgE6RqeMzleev6
	jwmy0QiUBhgxgWTc4B4fqpCWkseI9a5fJ1X/yZKbukZ9lkcS2KyRAfZkp5kh8Gf9XGnR1fz5kE0
	RSYFp53bhRWRvncfyZSdF1GQ+aauKGeCxeLXQI9k4lBmzOpHzZ7r+a/OcdNgsoa0AIdTtjj2GA4
	rMi56jYHUiNBkqsW30xrlT555gqh8a5hB9VtnKJyvtK2SngUNjeiqQaQtOAN+nQJLe+ABAY+Jov
	Yl3Xj1hUgushFN0C5N+vdt8XRMd8Yg==
X-Received: by 2002:a05:6402:2688:b0:658:cf28:90ed with SMTP id
 4fb4d7f45d1cf-65949cc1e5emr3920680a12.15.1770284249654; Thu, 05 Feb 2026
 01:37:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260204050726.177283-1-neilb@ownmail.net> <20260204050726.177283-12-neilb@ownmail.net>
In-Reply-To: <20260204050726.177283-12-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 5 Feb 2026 10:37:18 +0100
X-Gm-Features: AZwV_QjDs8XEOiRuWGAHzisKUrokVjcatEGo5N0FYjLzK48UQXH5p374RE5BkHo
Message-ID: <CAOQ4uxiYUTi=8BjRFbY_GdBZR_5CuP6680me=_xQaPcQk7EFuQ@mail.gmail.com>
Subject: Re: [PATCH 11/13] ovl: use is_subdir() for testing if one thing is a
 subdir of another
To: NeilBrown <neil@brown.name>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	John Johansen <john.johansen@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, linux-kernel@vger.kernel.org, 
	netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 4, 2026 at 6:09=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote:
>
> From: NeilBrown <neil@brown.name>
>
> Rather than using lock_rename(), use the more obvious is_subdir() for
> ensuring that neither upper nor workdir contain the other.
> Also be explicit in the comment that the two directories cannot be the
> same.
>
> As this is a point-it-time sanity check and does not provide any
> on-going guarantees, the removal of locking does not introduce any
> interesting races.
>
> Signed-off-by: NeilBrown <neil@brown.name>

Looks reasonable

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/super.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index ba9146f22a2c..2fd3e0aee50e 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -451,18 +451,13 @@ static int ovl_lower_dir(const char *name, const st=
ruct path *path,
>         return 0;
>  }
>
> -/* Workdir should not be subdir of upperdir and vice versa */
> +/*
> + * Workdir should not be subdir of upperdir and vice versa, and
> + * they should not be the same.
> + */
>  static bool ovl_workdir_ok(struct dentry *workdir, struct dentry *upperd=
ir)
>  {
> -       bool ok =3D false;
> -
> -       if (workdir !=3D upperdir) {
> -               struct dentry *trap =3D lock_rename(workdir, upperdir);
> -               if (!IS_ERR(trap))
> -                       unlock_rename(workdir, upperdir);
> -               ok =3D (trap =3D=3D NULL);
> -       }
> -       return ok;
> +       return !is_subdir(workdir, upperdir) && !is_subdir(upperdir, work=
dir);
>  }
>
>  static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
> --
> 2.50.0.107.gf914562f5916.dirty
>
