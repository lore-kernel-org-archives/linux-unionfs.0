Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFE22D2397
	for <linux-unionfs@vger.kernel.org>; Wed, 17 Jun 2026 13:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781704074; cv=pass; b=RC7C7ZP+ocvuJ3w715kLDP7D4dSc1Q9lGQ+zvc1huqaRyCS29OfE0aOTd+Ozli9vV05nBYxjs8YzItgF5DEdEsgwqOr4DCfnRUocRcLfCVFyShoP3UWNFYlubKt/yRzOA9aYmFB6lqQVMjlkrmzAleX7twPQTB53UQugpkP543w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781704074; c=relaxed/simple;
	bh=nM8r/px9H7v/tHYNgNd0qH7K7eDqiE8FyYEm7qDudTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NtDqO8B9WhvqkD0TZznxuQafopoS0F4A2jiY1yQEzebylla1qQjz2guHAJn+N02rkUJfR5ln9x9zlEfapXZwVDmx0UmKu0f8O5L/q006fGlf1IpHEQreG+GU2rO1AgAauUZcLoZWIMWQP0V5NHOrh4jhQq+fIZekdkZrINdQeWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=atpeuxCQ; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="atpeuxCQ"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bec405a6ea5so829637666b.0
        for <linux-unionfs@vger.kernel.org>; Wed, 17 Jun 2026 06:47:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781704069; cv=none;
        d=google.com; s=arc-20240605;
        b=gT3Hp9qkGKq1U7qEAu2V69xGvOkAbln2N+cgHPPz7KiwZC1WkCluzjIuux6WXPJ3Fn
         /qp3Rbr48s+fG9Bw+zK9003yVhr+ix1jweS+1g2D6gDsD+Ue/mrQVB7QaJQbLwomMZOz
         MGlefWbrom604ZDCaYENYsa+/pYDF7GnhEoWwcFW9bGxubd94WCM7InalmrzRbrQIVy6
         we5d/ftaFuJUt90W5QjbmU/94pSPAUZEuznJMkILZEnht+11NeZ7kz3EKhL5tWarVU9D
         hxubmjDT+gFP1angb1DV5V582DL3pKZbur8xgUpDxa+XfleNUjsaNYprVyq7uyG4qpDf
         c2jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ILDtdQoYcmNGPD56O0qnXW+XsYYGZpRpGru6zWmT3R0=;
        fh=GxuFlwaDMbYAqMFhJXkdXvkFbrTt4SMVri06xzOYyGg=;
        b=gwHPzjiBgcndVgZW+ooGnlyhpFyJAp89JO2SDJbsSmwwkv6SUn/8oLtGR8uJonHnM+
         4H8+e5VAlpUD5hgQoxts2XAU5ZVQ0OE2lpUDxmg/3G5MQISviuRKVKpjzPIYs4hC8yws
         6TM1kxLf5QmUMvrWAZ7BlqCHIMLnpfKmRxQKwtJy2ZD58xZmxFOyOa/XF8ddO06H7C9q
         nEdzZQpxOEOqwP4dI7l2Fux+URlrZJ5KBQZy9atnczVDpuDcsp4v1agIqHUonryOE18+
         vzXMmgeO86bcpFdtwzyqrh3BghNjhsCqaSOOq8d2yWMLaLm91ZxpDC9CH4cWW33/8m3d
         65GQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781704069; x=1782308869; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ILDtdQoYcmNGPD56O0qnXW+XsYYGZpRpGru6zWmT3R0=;
        b=atpeuxCQ++cnee2bpmNPqpU8IUSeCFPsnGNOUkgPUvFoDc6/igyTAbewzLdAERiGnM
         vb6z+iAdBOGiPQZYNto4I9L8c0q+mJu5n21GpZptxB2UPnsMiqZyaHsPO/I3wOlf7Fe3
         u/qgQF5jTmBT0T3IxlTx6e1pzX7Esry6aiC2jA5zh+6C18NeHRVa/XqF9NaCdGcNzD7U
         IrP+SM0Vd5m1a0FbmXl/06mBXKpLF9lzxxXvuNT8hMpMRTR6TIHE+bGXdzqNFeRGQIHF
         B5ud5kh5EADyX9Fhcj6m9j1hFy294CJCQ9qRsTjdhvAljBwd5QnZmqI2cJK0i0tQXTUO
         BIpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781704069; x=1782308869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ILDtdQoYcmNGPD56O0qnXW+XsYYGZpRpGru6zWmT3R0=;
        b=d/R4uw9Ew9v48l0F/qA3As0dqJE3bzrPYOQE8fGHWkIYzbE7Tf4uueTGkOXOtC7DSn
         RqCLr8hkFLAcULL2SmLRUfjxdHpCFvHWk/GWsei4DlvpfzF8QytStaubBicE4Nmde0/S
         gZDBqUHq2svEbwN2ZMxhnI8IOWzgmUw8gI60uFa6WNehG7aeC80f0QkMJS9LN8uYQ58q
         yz9j6zqi117v9Uri4nGwYHbKfCPhNW6Ch87H/RXnCLxxGhRYKIAbYHZdUXltPS7qXWx9
         lAydsAG+b+H5ouMbCr5yzMBL8pK3cu6796eBGMNwXw9wumCoqHk37vrhhe5ybZVn+N8o
         txXA==
X-Forwarded-Encrypted: i=1; AFNElJ8001Dac8l+URBp5+WIrFyfgeSt9PfOWTVQp4JM/LYGWoemzxJKX4eeQ6R6fF7chraJGIfFNaAZ8JN56WS8@vger.kernel.org
X-Gm-Message-State: AOJu0YwA9gmt0IGqse8A/WjUoo//FHIiiC+mpCEi3Hm56vBAe/wGfuVo
	VNVLDESgDPYXSy4fLYMcaktgK+8VckLQhc6SF85gMJKYjpMKT6KRATvNONHREBX9GSdPCp9fzv5
	TYChLHlDiUgoB5ihVHH5xMQbYkY567sg=
X-Gm-Gg: Acq92OHLs9WqvAajIDquLu64aUbpBl6Vvaplw/bUJCYqnanwoQ/cE+BgrhjQFEbm/nF
	l5cBwNHm6WOlKyNAYJ7gAOQW6+ulRI44rin7MeRHj4XP8AYpVWtomzRTjXgyZnjZAH4OP/KnpB2
	RvW3/gi0NH3BzpWB5+CFEy0TMk2oIPOu2EpohLu4w24uIfBSpCRO87iSt8QNMvV3PdKCYDGyv97
	Mze4I6a+5h31m6bvUxRZxycxn4Arj1AMEAyZc++4N6NjFZhsyC7nKjGVlCx+HI9cUpbODb7TzuJ
	x3KrqOx+lLEcSLtK+4ck2RZ+lOpSE6I=
X-Received: by 2002:a17:907:3f0e:b0:bf1:8145:c300 with SMTP id
 a640c23a62f3a-c05d2182a42mr204224766b.3.1781704068936; Wed, 17 Jun 2026
 06:47:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org> <20260615-work-idmapped-overlayfs-v1-3-7381632aa402@kernel.org>
In-Reply-To: <20260615-work-idmapped-overlayfs-v1-3-7381632aa402@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 17 Jun 2026 15:47:37 +0200
X-Gm-Features: AVVi8CcEconpeqhBOyuB-_I5gU5arq4VBIDYPQCkGUDoShE8kWT7dvLar1E8_TU
Message-ID: <CAOQ4uxiK_GruYMcqekrf+iF1a2y=VksFw71XOW=Gsf3GV0kAgg@mail.gmail.com>
Subject: Re: [PATCH 03/10] ovl: handle idmapped mounts in ovl_setattr()
To: Christian Brauner <brauner@kernel.org>, Joanne Koong <joannelkoong@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 3:20=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Pass the mount's struct mnt_idmap to setattr_prepare() so that the
> permission checks for a chown/chmod performed through an idmapped
> overlay mount are evaluated in the mount's id space.
>
> The ownership requested in @attr is expressed relative to the overlay
> mount idmap.  Before forwarding the change to the upper layer via
> ovl_do_notify_change() - whose notify_change() applies the upper layer
> idmap in turn - rebase ia_vfsuid/ia_vfsgid into the overlay's own id
> space, i.e. the same space as the overlay inode's i_{u,g}id established
> by ovl_copyattr().  Without this rebase the upper layer would interpret
> the caller's mount-relative id as an upper-relative one and store the
> wrong owner on disk, or reject it with -EOVERFLOW.
>
> from_vfsuid() returns INVALID_UID for an id that the overlay mount
> idmap does not map; that invalid id is carried faithfully into the
> forwarded iattr and rejected by the upper notify_change() via
> vfsuid_has_fsmapping(), so no bogus owner can be written.
>
> No functional change until FS_ALLOW_IDMAP is set on ovl_fs_type; until
> then the overlay mount idmap is &nop_mnt_idmap and from_vfsuid() is the
> identity.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/overlayfs/inode.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index f59db57dfd55..33734ca971e1 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -26,10 +26,18 @@ int ovl_setattr(struct mnt_idmap *idmap, struct dentr=
y *dentry,
>         bool full_copy_up =3D false;
>         struct dentry *upperdentry;
>
> -       err =3D setattr_prepare(&nop_mnt_idmap, dentry, attr);
> +       err =3D setattr_prepare(idmap, dentry, attr);
>         if (err)
>                 return err;
>
> +       /* Rebase ownership from the mount idmap into overlay id space. *=
/
> +       if (attr->ia_valid & ATTR_UID)
> +               attr->ia_vfsuid =3D VFSUIDT_INIT(from_vfsuid(idmap,
> +                               i_user_ns(d_inode(dentry)), attr->ia_vfsu=
id));
> +       if (attr->ia_valid & ATTR_GID)
> +               attr->ia_vfsgid =3D VFSGIDT_INIT(from_vfsgid(idmap,
> +                               i_user_ns(d_inode(dentry)), attr->ia_vfsg=
id));
> +
>         if (attr->ia_valid & ATTR_SIZE) {
>                 /* Truncate should trigger data copy up as well */
>                 full_copy_up =3D true;
>

Won't insist on this as part of your work, but would be nice to
take Joanne's patch [1] first and make this change in backing_inode_setattr=
()

In any case, Joanne, watch out!
Fuse already has FS_ALLOW_IDMAP, so your passthrough inode
series must take this into account - now you have the template here ;)

Thanks,
Amir.

[1] https://lore.kernel.org/fuse-devel/20260516004004.1455526-19-joannelkoo=
ng@gmail.com/
