Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6A91E0E01;
	Mon, 18 Nov 2024 18:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731956087; cv=none; b=dtrZOWISu7i7baCGrw6IMqHLMTsOD+ysvdy1GJk8CRmXTFFraDD9mLFJvgXz4Ng19QXuWW0XCdrg5pqTzU0/kRp5yFw0BWjB0fXMbBT+UXcvBwuwOqNgVR14tmGuBRMDmncPkphyUYibVzTT1REODd4RRW2kvwzKmydLIYRCauQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731956087; c=relaxed/simple;
	bh=DstAgx3ogDOzxs37LnyAk7qZORc4VHUojGcMcTnHQP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P5BMKlz3kaLnqxQBq17fnjwQhKuMDUrGKj78F+6s6JNv2BkiDwiYBOlz6qkwtTpY3W+c75I1ozDsiHcPF93d9DaRATwR1/vkHqnM0NBE2egpUKLJ9T3QPJi8zWPfWYboHCkEh4dbeDUgX2KOl+RZipCEcoaMWNhBW7jsApcQf8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K4mWQGUp; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K4mWQGUp"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9a6acac4c3so20491466b.0;
        Mon, 18 Nov 2024 10:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731956083; x=1732560883; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNbu8U7gi8hrtE1jwyMs7E81Ghy+rLRP6wPyAxZzLx0=;
        b=K4mWQGUpAQak1lkF6K31LvWtZd3gO3d/c4IHPnADg8zJzz2WBkDlCSTrx2UONIdAHV
         QkHS+tyoNlGw5Xh7sc08va5i1CmasoVU2er5PW+n2gp86xsbPVbAwioCluqTe2XWBLwd
         tl4hDQjs4KhI3DzfZOeBpaUD3w/wt84RqZvVe1zhAkhHt6KgiTo7yREfCzVW/nMeA9OF
         4Vek4DCeXlj3YWlniw16F/2C1qtMGNIlGT7O3wfKEc2dUu0mytIfsib6zZbKDuoTitTK
         0GbNoWrnUPpkTMvwJdIBjOHapMF4ALG8/1cFvmpFb1eBgnET9L1WmL0ItL6xzbSWuNRs
         Rm3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731956083; x=1732560883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QNbu8U7gi8hrtE1jwyMs7E81Ghy+rLRP6wPyAxZzLx0=;
        b=jeS9qhWPD7WPeAjjPnOqaBwQWw170wo0bi0PtHsTR8Bh/gm3ZBchHWvJOWI2G53r7e
         nz2o/pUJNKSUHD6fgdogsK/YGT+d3tThAtgV/cMY4qC/YfYs/AexuSXveSIAZou+Z6iw
         uSGccl+G8pZ4xaezbM2zEjOFbcy8ka6vQYg0X0gcnNTSNVo4a1OK3t48UWFNYWVPR8MZ
         LJbD3VmybiU8hCtswcAVcfrEgz+3FWjiiLUE+p/VHnK2bt5FekfgQ5w2X72chCGmpQWF
         WrV1oGuuulqw3fUFrU0Q7CM6KWS4nOIlV9awtnxHidkxHBgNdSEYrAhTmqQmLsCm+gfc
         IIfw==
X-Forwarded-Encrypted: i=1; AJvYcCUATBZHAXFqb17R8fp86dFAdvoCYJpza18IunZwKAbkJw5lc8d6Cj/ivuN9GWAGQEArPC5/6MGwtJddbg0=@vger.kernel.org, AJvYcCWlnTy3jz+MilmIyFsL2WkNBXi0RpNijjZNifmXL2WkrJvtDyK9VQhx6DrjR7P1OR/wCNadLdv9CWzo/YdOTw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu+xKm1yrUmKVgl+vw1/W4jsNzV3230dKEa1E7pwjqRr9Pbvi2
	sMvb05OfookldzHnOQV1/rYfRmw9GJcHwchdd57tcrdsj5IHJIQJIbXp0yLjGhV/UIOqyhoGsWu
	jOWIdpnK3xfi5ZRPxgSQTWY/ytc0=
X-Google-Smtp-Source: AGHT+IHrV7K8Cyj7YJ65WKJq9jdVDZI/Pp/TvrOcTY9H7suj5TqX5ZMTdvHwo3LxSOTlhRS/1fgE+k3FVKbnWZIUTkg=
X-Received: by 2002:a17:906:c10a:b0:a9a:8a4:e090 with SMTP id
 a640c23a62f3a-aa483552321mr1242001566b.50.1731956081850; Mon, 18 Nov 2024
 10:54:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118141703.28510-1-kovalev@altlinux.org>
In-Reply-To: <20241118141703.28510-1-kovalev@altlinux.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 18 Nov 2024 19:54:30 +0100
Message-ID: <CAOQ4uxjxXHX4j=4PbUFrgDoDYEZ1jkjD1EAFNxf1at44t--gHg@mail.gmail.com>
Subject: Re: [PATCH] ovl: Add check for missing lookup operation on inode
To: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2024 at 3:17=E2=80=AFPM Vasiliy Kovalev <kovalev@altlinux.o=
rg> wrote:
>
> Ensure that the lookup operation is present for the inode in the overlay
> filesystem. If the operation is missing, log a warning and return an EIO
> error to prevent further issues in the lookup process.
>
> Reported-by: syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Da8c9d476508bd14a90e5
> Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
> ---
>  fs/overlayfs/namei.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 5764f91d283e7..a73f37e401cf0 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1115,6 +1115,13 @@ struct dentry *ovl_lookup(struct inode *dir, struc=
t dentry *dentry,
>         for (i =3D 0; !d.stop && i < ovl_numlower(poe); i++) {
>                 struct ovl_path lower =3D ovl_lowerstack(poe)[i];
>
> +               if (!lower.dentry->d_inode->i_op->lookup) {
> +                       err =3D -EIO;
> +                       pr_warn_ratelimited("missing lookup operation for=
 inode %p\n",
> +                                                               lower.den=
try->d_inode);
> +                       goto out_put;
> +               }
> +

This looks like it is papering over a bug.
The dentries in the poe lower stack are supposed to be
d_can_lookup(), which means that they should have a ->lookup op.

See in ovl_lookup_single():
         if (!d_can_lookup(this)) {
                if (d->is_dir || !last_element) {
                        d->stop =3D true;
                        goto put_and_out;
                }

Can you analyse what went wrong with the reproducer?
How did we get to a state where lowerstack of parent
has a dentry which is !d_can_lookup?

Thanks,
Amir.
