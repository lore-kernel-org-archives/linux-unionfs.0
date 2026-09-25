Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17C44B66F8
	for <linux-unionfs@vger.kernel.org>; Fri, 25 Sep 2026 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790348722; cv=pass; b=aSgaL90786qf6zeiwoV313uAbgwMxggIhBrcrUobchnSfr8QXd72w8IGRVa4hl4QMrZYzG0xTP8fCpYgZo+P+xPB0JjvgAyvV3M9iebSDbqz3lIDN3mEN/R2wAkQq2Xu9FAHQzYijlh2oeUgFGX9s4T8D7I9ckOQ+IHxF/CvX/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790348722; c=relaxed/simple;
	bh=WAWqhJNmyo51Od5KW8SJ0vK6DSlgvw2LcK3VD7saVMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ObO9acliI+bVXnmYba1BrKlKQhjd6MzqDGSMu8oy4O80Ee7iZ9s3EEKO/elC3/lAOid45cOFL2y+mzOyOab4pmpyQWhYQ/Fhgb0aLE2YtTvOi9FEfc3QMduDW7sI/GHy54mNgXGpfBm1ur9ZaFnojX6mEKFezN85uymXNC4adcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EjQmcmay; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EjQmcmay"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a996c8adf3so1716295a12.1
        for <linux-unionfs@vger.kernel.org>; Fri, 25 Sep 2026 08:05:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790348700; cv=none;
        d=google.com; s=arc-20260327;
        b=oCKpZZRAtymGgu3nBZTGBB8dkyZ6H/G2+9MdA2g3rToWH9LNb1a5Rkzy2YbOYzZVB3
         +UQlJZpRc5F94w0YdW+URwiWsoh3d5G9NePk62JcC6KdpkQ40IczZX+7xerOzNJG8jZt
         6hIQNUOgn2w8PlKTb6aKpdNs7ffEA9ayTr/UcMWB+ogsQe1xIJi0N9xNscL+/rEZV6Mr
         fBXBKSs942iN9bHDPmKlj/8vguBAFgsP6WcDMpT9hjUNDmaZ+LAwXEQ+uiyBqX3p9NsX
         UA0hRVcNIqRNKRcgBovI8j3Fx98MoHr6Ts4gDX9+hADLOM8IvFVtdTzn/hgwRckzHW64
         JWHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x6h1BVvc6NlZ/1f8ypPzy3ocqWyFlnaev/ls/pKUnb8=;
        fh=iW1uSiIiMyx+Lr++6QIJ/sOk7y76HGHHL5axZxBnT0Y=;
        b=sycTv5rVaeH9e6RLAYp5VPaL2O3G06GlgkCeO8M5WSo2f3m+Hu9wEYcp8Lvaktq3v2
         m8VDsTi2L1mrrNQsLUmZz6rGIQB6T4WpCqcueLiv5HLt/xGTo9Z5bLaBB06Sya0NMP7O
         XWFwjsf4QKgeQabLrTSI2q9JjZNQNMDy6kBPkJxV4GU1rXXyFeJ4SuhvRS6m+tu1Y9h4
         /G2ctTRWMBQ3+o9p73ZWXTTZS6ItEXjM8olNzLLtwrhP9u4V0cIsF6eVn1sB5L6/HduD
         PC6/3tPDatGgFwjHz5DNf9RM8IQFSKHfsOzKPaKXOtI68h3EyCjQf2yeI2BUR3DDh3MU
         m9kQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790348700; x=1790953500; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x6h1BVvc6NlZ/1f8ypPzy3ocqWyFlnaev/ls/pKUnb8=;
        b=EjQmcmayCVkHHRheUxRBMKhMGxjjSG3w9P62Mo/R5MrPRDrQ7AtdMFociIibDGvO9Y
         lTB8UjLcG90to0VIOsJSOyoOgbWhm8Jbl+3FqPP9uTzEgkKEZYXB9omRzSLOh2VWnB4/
         qVgnSgh3i7vc7m5ApBRXVzyfjoPU3TyNN1n6FVxFwVvDlP2fuG/OrjI4av6aOZQjJtHn
         V+p8BP9VmGllwqsx5kUqGHzDNSdHR08aCI7+UrpTMTRPtFfA2v0nSFxeG4VcrcwVtdHv
         iW6tD0qxn+tsWfoGbU/gUPDrWnWDkUMFI17wxrWnFFU8M1RRzO0K+CINdoJpjohcIITP
         gG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790348700; x=1790953500;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x6h1BVvc6NlZ/1f8ypPzy3ocqWyFlnaev/ls/pKUnb8=;
        b=DBYODhRKQHwYK+ZgwCzCRsMfD/eq/Bd6eJh8wi6ft/BXqNJ51v5iv+W8gzARFjeWKr
         er5VMhhsFljHOjz/6FPd4epfkmkxU/lTkjb4oXVekEhkQpwbZc7BUyL3DIunPQAgp0VY
         WJ7dT6Vk5mdjIFGkWs1j8f0JYI57dw4eMUCcMP+cI/rs8wwW3MtyOQTlk8xz3I2O02eR
         iLrjMQfgW1RjB6JszEmX3yvyLaCw8yhbxeaG7oEBLsEjrOX7WUq90fDzNlFXoCgG6QXY
         Sxi2Toe6OUTAZrBj/J+Rm8t7SpodIOS34GjWdYEdwW076qxeiclpHDd0DvlmStinbQK8
         X6qg==
X-Forwarded-Encrypted: i=1; AKwUvBw9TXgp8ya9Q2S11cg510mgPgM49NeFloIapwdsGEhTE7hEBRs32P3P0vKJkbtxZavhq1/ucXEHNE2mhuxi@vger.kernel.org
X-Gm-Message-State: AFuF++noHYA19QCL5T85Nl936CuvJq8vbkhf/HZQAEJkNdyLACZKNcsk
	NGH4QxtrwwG/quk5H8vz1mKjrqpj3VKX4bxnfQDxn31WnfPCCLqPL0fDyopl39qQaUmD/IRuJjS
	q8VTyE6xOPdq/vllKvkEG+CsxFlc+Df8=
X-Gm-Gg: AYBFou1ef+4gh1qY+E4M/3qsXLJaS7TTipwklYlgxt3K02r2u+MkQ9YdLjuvzAhKMgO
	i4bpyL48IBv741m4fPe0If/5lIKND/Ifai6Cf828XExcWTwTon1tx3e/XvgSXj+dreVdUmTS1TL
	YEJGicgBrvN+ITpMSs8olEHMbThqZYP5CO2Juch4F+TrNh/Q+ctc/nFNGpBhWgKG84xhuzduA3s
	QDqQrh/Fhyn+yyu1/LIGpJHUEroOX9e/ZEwSgjBXUyivaIC86wTOoXwS5BRGgBOHow4f3mQYWy9
	EApKOklsIqksmg9/8Z1XKHP8j8fqR1fC5xcUyPKvzcIQfznxJChcVUjC5w==
X-Received: by 2002:a05:6402:304f:b0:698:c13e:179a with SMTP id
 4fb4d7f45d1cf-6aac8f0fb76mr4307366a12.10.1790348699463; Fri, 25 Sep 2026
 08:04:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260924112858.51392-1-disgoel@linux.ibm.com>
In-Reply-To: <20260924112858.51392-1-disgoel@linux.ibm.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 25 Sep 2026 17:04:48 +0200
X-Gm-Features: AclHuK99bcpAkghS0fUG2lImCTNfTZaz5pVDj1Ros9PGZp_xBJVRQl4OTsgjcsA
Message-ID: <CAOQ4uxh+VbTTUTQxRZ6jxYCLyBedKEPOQAPEkrJwhbiL32eGPg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ovl: fix mount setup failing when override_creds
 drops CAP_SYS_ADMIN
To: Disha Goel <disgoel@linux.ibm.com>, Christian Brauner <brauner@kernel.org>
Cc: miklos@szeredi.hu, viro@zeniv.linux.org.uk, jack@suse.cz, shuah@kernel.org, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 1:29=E2=80=AFPM Disha Goel <disgoel@linux.ibm.com> =
wrote:
>
> When a process drops CAP_SYS_ADMIN and calls fsconfig(FSCONFIG_SET_FLAG,
> "override_creds"), overlayfs saves those restricted credentials in
> ofs->creator_cred.  ovl_fill_super() then wrapped the entire mount setup
> in with_ovl_creds(), switching to those restricted credentials for the
> duration.
>
> Mount setup calls clone_private_mount(), which checks CAP_SYS_ADMIN
> against current credentials.  With restricted credentials active, this
> check fails with -EPERM and the mount fails even though the calling
> process is fully privileged.
>
> Mount setup is a one-time privileged operation and must run under the
> caller's credentials.  with_ovl_creds() belongs only in post-mount I/O
> paths.  Remove it from ovl_fill_super().
>
> Fixes: 539a0879de47 ("ovl: allow to specify override credentials")
> Cc: stable@vger.kernel.org
> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
> ---

Hi Disha,

Thanks for the report!

>  fs/overlayfs/super.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index bd0a3f9039d2..29f9489b8242 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1557,8 +1557,12 @@ int ovl_fill_super(struct super_block *sb, struct =
fs_context *fc)
>                         goto out_err;
>         }
>
> -       with_ovl_creds(sb)
> -               err =3D ovl_fill_super_creds(fc, sb);
> +       /*
> +        * Mount setup must run under the caller's credentials, not
> +        * creator_cred: clone_private_mount() requires CAP_SYS_ADMIN,
> +        * which override_creds may have dropped.
> +        */
> +       err =3D ovl_fill_super_creds(fc, sb);

Without ovl creds, the name of this helper is a bit odd..

>
>  out_err:
>         if (err) {
> --
> 2.45.1
>

Chritian,

I see that selftests are failing on upstream:

#  RUN           set_layers_via_fds.set_override_creds_nomknod ...
[520332.680688] overlayfs: failed to clone upperpath
# set_layers_via_fds.c:516:set_override_creds_nomknod:Expected
sys_fsconfig(fd_context, FSCONFIG_CMD_CREATE, NULL, NULL, 0) (-1) =3D=3D 0
(0)
# set_override_creds_nomknod: Test terminated by assertion
#          FAIL  set_layers_via_fds.set_override_creds_nomknod

#  RUN           set_layers_via_fds.set_layers_via_detached_mount_fds ...
# set_layers_via_fds.c:711:set_layers_via_detached_mount_fds:Expected
layers_found[i] (0) =3D=3D true (1)
# set_layers_via_fds.c:39:set_layers_via_detached_mount_fds:Expected
rmdir("/set_layers_via_fds") (-1) =3D=3D 0 (0)
# set_layers_via_detached_mount_fds: Test terminated by assertion
#          FAIL  set_layers_via_fds.set_layers_via_detached_mount_fds
not ok 7 set_layers_via_fds.set_layers_via_detached_mount_fds

oops, I thought these were running in CI...

Apparently failing since v6.16-rc1
c28f922c9dcee ("clone_private_mnt(): make sure that caller has
CAP_SYS_ADMIN in the right userns")

The question is whether doing the guts of ovl_fill_super() with checks like

int ovl_can_decode_fh(struct super_block *sb)
{
        if (!capable(CAP_DAC_READ_SEARCH))

Without the user provided override_cred is the right thing to do.

Could lead to confusing state post mount.

Thoughts?

Thanks,
Amir.
