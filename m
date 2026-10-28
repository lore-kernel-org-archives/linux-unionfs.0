Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793202516;
	b=u8OkXUOCzUkJ6hd7B/13Q0/p8BTPs4cRe6ueSXapMqJnC2HcaMbRsi0n2KYnbekADk1+
	 xv/Ws5EEaTdq7tAB2nOi3VhBx5cxBg/cRJc1ZR3D6FFL0TlO+V6XxYAmIi8z9jUMxihUU
	 0gHxLmlrUu3g+ZHMj+pCC8dI9ns+5+diqayCRcKN5ujRgO/B3bBRc9OmxCTGkCJGpjTF6
	 eVxBGAN1D67NIbgiKX8faKMlMcyHBzgUo0SHNWgdRanPYSL3LZ/pG1e2DyUT8zoWOhVuT
	 ZfZ3saoZM22DuwCMLPrMmSNz84hcb40MLSdx0md74qGdX8TUXHVzn83nQUC2Tr1/HUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202516;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=P2Gtmc+yPPyy4dGekEnPEtmKjhHWq0oqn8nEo9QjzPA=;
	b=e4eu5UWDCJgKKAxyagOx6KHlOmRsGV+wgWrbwN2C9GQ5il/5v5yXS6PBE8eR6+v+17oD
	 +iWLNBo1+kdLqJ3Pp+NWRTWkD7mNELEQ7lhyfhi4Gv3GrGFZtxFumG+VKfqgXIvjzDwuf
	 7tZuapwYqmlP/5voPBEhMcgP7ErGCjBXz3/2ee64f7i1kEHezCY3h4jbkdLpSZT6x+Wd5
	 zt32tMMEiZ6O7wyaZcyt5yPE0UELupDBwAhKr2d0ELp29Tk99dQu2IPzJiy2kmAdnu/oj
	 y9hV+UeI553QMjW6fojXhTM48FLP8Q/0hvIfghQZCqc7N6/z9p4hWM9yco82iLdG5Qg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sR9JdKFc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533E1606A329
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 15:48:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 533E1606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sR9JdKFc
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso1970660a12.0
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 08:48:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793202514; cv=none;
        d=google.com; s=arc-20260327;
        b=WUf/HUSfjKjCQdiNi69kcxgMiMI9CouvzJCH18Pw3tOplF1SVFkIV8MtUCbj1npeqf
         1NJKgRLuiR7O5nOUNQO0ZSzkD5P5hzOO9aWn/DvrdD+C9QVH/YELFhXE24QlWrtdeUNw
         EaWJcG21SCnmlmFf4gBcYxoKCbDPOqoFqSvRq4Ye8Jv8Sv0QSkhuu6s0L6Z+pQfsw6ad
         qlLJ0xVjnnzpv9/Id6/kYYu8dilBRhGE9fsf5vglT2W8vJRER5Sj9KpvvbWG6w0gn8+G
         +yXO9+tp5bUWuQdIpM6Ehpb6iKo4NW+hzItgJz8zlWY/fiMN/Whad3ldqcRyGJFcU7Ue
         7t6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P2Gtmc+yPPyy4dGekEnPEtmKjhHWq0oqn8nEo9QjzPA=;
        fh=Tyvh+IrnFzamJ+UMtxiN8HbliVc8kxYTezcjM+soCd8=;
        b=RiKr3wDLWu/YlE18hTcUCd6aOD2o/SuFFG2pKdkhWjvFXXwXtYlxWwq+S0SsbKKPr/
         qCzceWMJe/uEglzRYuv2f3wJE3TEkd/hWz9DVZhXBqN6QNRRTX3gxI7xMIk4KvnBtgoT
         QV3JGOkkr1GDDLLTXJksRVhLHtNLqj1KCxxriLoPcnPNANubb+Tv8s7hXbNNWS0wyQkf
         PHiCJ0ngdEqhe3Rmo1bAjcSl1vVfoejMwIf9MK56iPuCdlUDA93wJ0UUKk5xEcUs/HY5
         km93y3GUXgH2hlhGsIx8P8BM8Oe/oaRqk0Fc9P147gIC3I5oWqwza16sv44E77eAswo3
         3uDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793202514; x=1793807314; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P2Gtmc+yPPyy4dGekEnPEtmKjhHWq0oqn8nEo9QjzPA=;
        b=sR9JdKFcgs0bpN4QkQ2MTdIADGBy0OfZK9Uc2xzngxH1OUHE6XPlgmotix5n04kE4V
         tKXhDVWcUi7R8x+WsSxO2XKULm2UrCLa5ugS8f2l/Nicboyg/Xq7P2T+CyBQwzwtUuSA
         00kvck2jyr72g40j3aOA8r0nVAnGYbDjdTazXmR+zx5OSZKFqq0rBsYi04jxNiTiLr2b
         b4k1CJpjGAKX5SIh8b5X0Vz9tLapvrzMIh1IAEh+zcElg7kBwxHx+E4aiBCISBHpzRVy
         sK/o6PxDR0wcadqZ7HwH7sh84bKXO5+wNcvDUBoiIhOwr2Otqj8bsp55EB6PBwliFnGI
         NU7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793202514; x=1793807314;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P2Gtmc+yPPyy4dGekEnPEtmKjhHWq0oqn8nEo9QjzPA=;
        b=v9oObbf9JfRPsc7bsiRMc7qkzk2ohfNqwYWu2k5ixjaG1LrQHhOSuaFuxqkIE+ad6D
         XW+oY0Ea3pFU4BuvaPrsAsuabjbZhYDIoqYqbMrDSkY0l1HTj2OsjVVaMEGxT1+gXZc0
         7lmUuKTdpVV2NYqJzD+sI+0hx9/8QGL7VFILOIesd/kINnXmBebvmHQd9K61BMOFWRdM
         VLuDq+KSbjv33enBW3yR6b38Q3IsO2jG6+qex2Or8qto5MBNqSMVExh5+4jIiPMcWros
         94JuN+MwVZLPWBla/zaU6cobQ253PShEbq15ROK2eeAcvpdJm/miXHdtcamytR/vjTBT
         bNRQ==
X-Forwarded-Encrypted: i=1; AKwUvBxEyGLCd3ahrgqx5doMZU5T7QWU4Kc2JLfYD/8syMF3nOwVW3dTilJNT9Vb7xc+lcXz3cQwUqwGfSlwaTRA@vger.kernel.org
X-Gm-Message-State: AFq9FYIvViM0AjHShCkT+yRpGuqnwQn28POScUH2FLj/FuZHyhyzEwss
	NFgjq+QxtBihFHDQD2vWWOAUlD1KD9Ij4vXPDZhEVZAvx6AyAldyzSCN5Ru1/JMd0Oc/EQgtX3W
	zOZcqIxrFUleoBnVQMd3uSbsiew7uFhI=
X-Gm-Gg: AYBFou3h2R5WCoXz07GYCfHFMerVDkixb+UDkIKKjyfYJ0QxwmWWnNJFNwajPyQK12c
	jw6S62SdaTucb8vQbsA1otazUnMEkphFEtXTAJk2qXenxuD/Tn7NTKD8mGsmKGUjaJ+I7XdXOX4
	jq5FwWSsrV789cA5ajzrFt3TYJSdWrEY+3q6RwRJCCLD+2akT+bp8a58E+NoJrE5t0ahUURuTWq
	AzH+7De9mn3xoANx/F/rys2bP9Slnu+JL065JGCLatzhvTfYSb+s9ZXfmf52z6oMwI2SqQdutgO
	L7TsfyN9IUdrjIfAOUfQ3oMGrNoCLsHVHHW+ebab0+IcEwT5rODAvrLjfL8dKb38hIWyT0jE/1F
	pu+p40RoOMFsvNc53NshSyABHIanxbHRuXiEfcJJglD32q7QyMGZTO4iKPKQbwVPhvqRooQ==
X-Received: by 2002:a05:6402:4414:b0:6b3:c0f2:eccc with SMTP id
 4fb4d7f45d1cf-6b49cbf6a9dmr2006612a12.27.1793202514481; Wed, 28 Oct 2026
 08:48:34 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <P4wUBaI--F-9@tuta.io>
In-Reply-To: <P4wUBaI--F-9@tuta.io>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 28 Oct 2026 17:48:23 +0200
X-Gm-Features: AclHuK8ls02xbX493_Bp1EqA0zzJpZtmFJofnLekSziZPblGB53hacKp5SDR2jU
Message-ID: <CAOQ4uxhT4i=UDvLmPAunehFujouFka8UKDCuB_exR4oSx_V01Q@mail.gmail.com>
Subject: Re: [PATCH] backing-file: inherit FMODE_NONOTIFY from the user file
To: Edvard Conrad <edvard@tuta.io>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 10:32=E2=80=AFAM Edvard Conrad <edvard@tuta.io> wro=
te:
>
> On Tue, Oct 27, 2026 at 12:53 AM Amir Goldstein <amir73il@gmail.com> wrot=
e:
> > Any chance you can post this as an LTP test?
>
> Yes. Written and verified, I will post it to the LTP list shortly as
> syscalls/fanotify26. Two cases: a mark on the overlay only, which passes
> on every kernel and keeps the test from passing for the wrong reason,
> and a mark on the overlay plus the backing filesystem, which is the
> shape that deadlocks.
>

Great!

> > Urgh I hate how special case this is.
> >
> > How about something like below (untested)
>
> Agreed on the shape, and it covers backing_tmpfile_open() as well, which
> mine did not.

There is no code that adds NONOTIFY to backing_tmpfile_open()
the only code that could add NONOTIFY to backing file is from
dentry_open_nonotify()

> As posted it does not fix the deadlock though:
>
> > -       f->f_mode       =3D OPEN_FMODE(flags);
> > +       f->f_mode       =3D OPEN_FMODE(flags) | fmode;
>
> Five lines further down init_file() calls
>
>         file_set_fsnotify_mode(f, FMODE_NONOTIFY_PERM);
>
> and that helper clears FMODE_FSNOTIFY_MASK before it sets its argument,
> so the inherited FMODE_NONOTIFY is dropped again. The backing file ends
> up at FMODE_NONOTIFY_PERM, which is not FMODE_FSNOTIFY_NONE(), so
> fsnotify_open_perm_and_set_mode() does not take its early return and
> still raises FS_OPEN_PERM on the real path.
>
> Measured in a VM on a defconfig + OVERLAY_FS + FANOTIFY +
> FANOTIFY_ACCESS_PERMISSIONS build of this tree, with the reproducer from
> the patch and with the LTP test:
>
>   kernel                        reproducer    fanotify26
>   mainline                      hangs         1 pass 1 fail
>   v1 (fs/backing-file.c)        ok            2 pass
>   your diff as posted           hangs         1 pass 1 fail
>   v2                            ok            2 pass
>
> v2 keeps your structure and routes the fsnotify part through
> file_set_fsnotify_mode() instead:
>
>         fmode_t fsnotify_mode =3D fmode & FMODE_FSNOTIFY_MASK;
>         ...
>         f->f_mode       =3D OPEN_FMODE(flags) | fmode;
>         file_set_fsnotify_mode(f, fsnotify_mode ? fsnotify_mode :
>                                                   FMODE_NONOTIFY_PERM);
>
> One deliberate difference from your version: it inherits only the "no
> events at all" mode rather than masking FMODE_NONOTIFY out of whatever
> the user file carries. A user file in the HSM mode (FMODE_NONOTIFY |
> FMODE_NONOTIFY_PERM) would otherwise leave its backing file fully
> silent, suppressing the events on real files that bc2473c90fca
> deliberately enabled.

The problem is that I wanted something more generic and v2 is
still very much special casing NONOTIFY and much bigger than
v1, so there is no gain.

Let's admit that I gave you a bad advise and a wrong sketch patch
and feel free to add to v1:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

BTW, pls remove Assisted-by it is not needed and remove the
newline after cc: stable

Thanks,
Amir.
