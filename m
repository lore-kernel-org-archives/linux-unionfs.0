Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C907D14884E
	for <linux-unionfs@vger.kernel.org>; Fri, 12 Jul 2024 09:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720777268; cv=none; b=cxggqImK1AJzmUD/D82BLXiCC0+0aqzaFm25QIuYHQLLeF2eDuO4AjvUX+ED2Vcn9m/M8tPdA3lQQ+5xUQzMSDWHnVwxr8K2ApP/IxmYyTrem+8nx0Wzm9TY0cAJbExmelRFt6u0KXPE2XT1IZo0aQMZ7u+V5haNsDVxYdfhqx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720777268; c=relaxed/simple;
	bh=aKQqsyidxSdQ59JsSe2EQEIeHL7pP01fpjNkmrBTJnE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P1RttuCaFv26+pQNopVGVASB14Jr2CmnZtNkCdd+GpY+je7yJQBBsc9jdYx31MhAoXmu5tabIVQxuSF55KIDVcbCFZLokw9M+Ade9Im49O3TDiDHvyAvkMejSYL3w78SSWhVrl70dvixy4Ev5Eskv4RV9fy+8W2MeJdCm/OExic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKIrBRSK; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKIrBRSK"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-79f15e7c879so121164985a.1
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Jul 2024 02:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720777265; x=1721382065; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kRoB9akN+9xsQ3aw3W8JfFfVXFUXY6r1JDhO57LG6jk=;
        b=EKIrBRSKqsSADw0l3jWtGrY8KAYugqQAAnvMuAfCDKebQPwvGddzyXcBTprVOKcnv7
         24DeTito0HwDeg5EkT9E525/kxv6SGBSLrWeagJ7piY5K968uYr+YJhgOrsLHRhScgWy
         IAgQQHFgh7OT9txi61mnrOjQ/BkNOVqrKxODT8xydczOwG8GE2SWW/k2le+hqIp/v7Qt
         AGyavG7gTNOAWq/ZufpniAqny+0VNOiyVhVdn743eqSL0iI74yGV7HLhMO8HrTppUI2u
         /k0GJMXVexi39t05w+Dlp/PxnaeoJ9RHSmxDhjqYxx3tNS/UVmf7azF1m1UABU6iWiAP
         sqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720777265; x=1721382065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kRoB9akN+9xsQ3aw3W8JfFfVXFUXY6r1JDhO57LG6jk=;
        b=GWYbY6btxl+Qr7PiFaKBxoM6gZAG76J6LzntBZU/DABmFY4LCFwnUWOzsZRmYqmdED
         C4ui+C7VPjb35apq3Bf9uNjy0k+V7vawr6pGFJ6UrKXcoOAZGYU0PSDtyqP31sErVKWy
         dyGATmek0wNekvFFEC1CBihDgZiMzFf56mGoAhoGXTHqc8PpZdD6IheFPAhqktl8XI1U
         lPLq/GWo2OtLR4Wh69TIn1ZxfeHx2A7e0E8dPcbuu3RNmEE3drRFcttYyOs7UzQY1055
         Wq2v6FbGHEnZLn3p9ZzvzDvniC3nOl26vf44TaU4bplQO/QkwfDYspfT8uAbAOts6a51
         y28A==
X-Forwarded-Encrypted: i=1; AJvYcCWsIysovo9K+J257KcelMlRdYEz3J+p7OqKoGSJY5fQ1SQ3j9nkUXUaeMFb22ClLu64xyV23smMR4i315/5aRv0LkIeVNV20L03vALQFw==
X-Gm-Message-State: AOJu0YzWTxdgXL0eDvJtfZnO0abb2hPdP+SLjoimFiU0w7AsLs7vSwuD
	pZFdzwxXRbxSeqR4lDJChBGHsUXINhdByJq7YyEeu3eR8TnhevirluO6Hvx0wWrqw5MpvL6yJQy
	+VYrsn9KVeBv+fBGkzy60NL/EoPG4jBlyBag=
X-Google-Smtp-Source: AGHT+IE2jACj8H3IaNwXTXrxWSveXq/6TQ5j1Ip+Up9f7J0goSNbNR4mTAmuLqQ5JAJgnx9S8KgY5g7EZ2O7b1ut8To=
X-Received: by 2002:a05:620a:1905:b0:79f:104a:ba4e with SMTP id
 af79cd13be357-79f19a5270fmr1596575185a.13.1720777265338; Fri, 12 Jul 2024
 02:41:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a2391c78f3974c5d92aa53574bde4eca@exch01.asrmicro.com>
In-Reply-To: <a2391c78f3974c5d92aa53574bde4eca@exch01.asrmicro.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 12 Jul 2024 12:40:53 +0300
Message-ID: <CAOQ4uxj-pOvmw1-uXR3qVdqtLjSkwcR9nVKcNU_vC10Zyf2miQ@mail.gmail.com>
Subject: Re: overlayfs issue: dir permission lost during overlayfs copy-up
To: =?UTF-8?B?THYgRmVp77yI5ZCV6aOe77yJ?= <feilv@asrmicro.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 12, 2024 at 7:18=E2=80=AFAM Lv Fei=EF=BC=88=E5=90=95=E9=A3=9E=
=EF=BC=89 <feilv@asrmicro.com> wrote:
>
>
>
> Dear Amir,
>
>
>
> Seems issue disappeared with below changes, can you help review below pat=
ch?
>
>
>
> Thank you!
>
>
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>
> index 48bca5817f..e543b5563d 100644
>
> --- a/fs/overlayfs/copy_up.c
>
> +++ b/fs/overlayfs/copy_up.c
>
> @@ -851,9 +851,11 @@ static int ovl_copy_up_one(struct dentry *parent, st=
ruct dentry *dentry,
>
>
>
> int ovl_copy_up_flags(struct dentry *dentry, int flags)
>
> {
>
> +       struct super_block *sb =3D dentry->d_sb;
>
>         int err =3D 0;
>
>         const struct cred *old_cred;
>
>         bool disconnected =3D (dentry->d_flags & DCACHE_DISCONNECTED);
>
> +       unsigned int copies =3D 0;
>
>
>
>         /*
>
>          * With NFS export, copy up can get called for a disconnected non=
-dir.
>
> @@ -887,9 +889,14 @@ int ovl_copy_up_flags(struct dentry *dentry, int fla=
gs)
>
>
>
>                 dput(parent);
>
>                 dput(next);
>
> +
>
> +               copies++;
>
>         }
>
>         ovl_revert_creds(dentry->d_sb, old_cred);
>
>
>
> +       if (copies && d_is_dir(dentry) && sb->s_op->sync_fs)
>
> +               sb->s_op->sync_fs(sb, 1);
>
> +
>

I am not sure if it is acceptable to add sync to parent dir copy up
although this should be relatively rare so maybe its fine??
but if you do add sync you should be using fsync on the copied up
parent directory - not ->sync_fs.

Anyway, this check is wrong.
You should not be checking for d_is_dir(dentry),
you should be checking if any *parents* were copied up,

See more about this below...

>
>
>
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Lv Fei=EF=BC=88=E5=90=95=E9=A3=9E=EF=BC=89
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2024=E5=B9=B47=E6=9C=8812=E6=97=A5 =
11:35
> =E6=94=B6=E4=BB=B6=E4=BA=BA: 'amir73il@gmail.com' <amir73il@gmail.com>
> =E4=B8=BB=E9=A2=98: overlayfs issue: dir permission lost during overlayfs=
 copy-up
>
>
>
>
>
> Dear Amir,
>
>
>
> Sorry to bother you.
>
>
>
> Recently, we had a problem with overlayfs dir copy-up flow.
>
>
>
> Description:
>
> If a dir eyelyn/ exist in low layer, not exist in upper layer, after crea=
ting a new file(e.g. eyelyn/ eyelyn.log) in this dir from overlayfs, permis=
sion of eyelyn/ may be abnormal after power-cut.
>
> If add a sync after creating a new file, permission of eyelyn/ is always =
correct.
>
>
>
> Kernel Version:
>
> Linux OpenWrt 5.4.276+ #25 PREEMPT Fri Jul 12 02:21:17 UTC 2024 armv7l GN=
U/Linux
>
>
>
> Test Step:
>
> 1. mount =E2=80=93t squashfs /dev/mtdblock19 /system/etc
>
> root@OpenWrt:/system/etc# ls -l
>
> drwxr-xr-x    2 root     root             3 Jul 11  2024 eyelyn/
>
>
>
> 2. mount =E2=80=93t ubifs ubi0:etc /overlay/etc
>
> root@OpenWrt:/overlay/etc# ls -l
>
> drwxr-xr-x    8 root     root          1360 Jan  1 08:01 root/
>
> drwxr-xr-x    3 root     root           224 Jan  1 08:00 work/
>
> root@OpenWrt:/overlay/etc# ls -al root/
>
> drwxr-xr-x    8 root     root          1360 Jan  1 08:01 ./
>
> drwxr-xr-x    4 root     root           288 Jan  1 08:00 ../
>
>
>
> 3. mount =E2=80=93t overlay /system/etc -o noatime,lowerdir=3D/system/etc=
,upperdir=3D/overlay/etc/root,workdir=3D/overlay/etc/work
>
>
>
> 4. echo system > /system/etc /eyelyn/eyelyn.log
>
>
>
> 5. power cut
>
>
>
> 6. after next power on, sometimes dir eyelyn/ has wrong permission (d----=
-----)
>
>
>
> mount =E2=80=93t ubifs ubi0:etc /overlay/etc
>
> root@OpenWrt:/overlay/etc# ls -l root/
>
> d---------   1 root     root           232 Jan  1 08:00 eyelyn
>
> root@OpenWrt:/overlay/etc# ls =E2=80=93l system/etc/eyelyn/eyelyn.log
>
> -rw-r--r--    1 root     root             0 Jan  1 08:00 /system/etc/eyel=
yn/eyelyn.log
>
>
>
> if we add sync to step 4, that is =E2=80=9Cecho system > /system/etc /eye=
lyn/eyelyn.log && sync=E2=80=9D, then everything is right.
>
>
>
> Do you have any suggestions?
>
>


Overlayfs creates the upper dir in work directory, sets its metadata
and only then moves it into place, so the above is an "issue" with ubifs.

The thing about this "issue" is that the behavior that after move the old
permissions cannot be observed is not defined by POSIX, but it is the
facto the behavior of most of the modern filesystems (xfs, ext4 and
most probably btrfs).

If you want to add a feature that adds fsync to copied up parent directorie=
s
for filesystems like ubifs that are not "strictly ordered metadata" then I =
think
this needs to be an opt-in feature.

I must admit that this requirement from the upper fs is not documented
and cannot be automatically tested by overlayfs (fs do not advertise
"strictly ordered metadata" property). It just happens to be true for most
of the common fs used as upper fs.

I wish we had called the mount option "volatile" "sync=3Dnone" and then
we could have added "sync=3Dstrict" for this and "sync=3Ddata" as the defau=
lt.
We can still do that and have "volatile" be an alias for "sync=3Dnone".

Thanks,
Amir.
