Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391901F9A83
	for <linux-unionfs@vger.kernel.org>; Wed, 12 Feb 2025 10:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739356550; cv=none; b=u79kBbiuqRVjVAkay7+Eg/Ff/ZomhoR1jNuVAD20hth6oJZNdH0fNmkFRZTmI2GvJkw7yHLtrnDJDPZdDaIOcXiNPL7vxDRz50A+kF2o3wPnBFxr3Vwz6alJkriSy6+iTJdLQ6gYc4NcOXzXtT9ckx9FTtuXKZbApXMBgOaCVaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739356550; c=relaxed/simple;
	bh=/eKSdt5S60poARbaafUPK9+3YVwfaDCyo+/NyjNnKKk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yui6QBzpbzRtBTEk+PQ0Mipqfk3AgN1JLIMOGe+lW3DE1ZKuXiRvcjCE+36rEGLlLjYldqrsv3+RNk8CBEUOSgIHJkCcR0cjr0BjhT1phoA3whihttLrETibgtla9SJHr0Ht7mdFxDQ2qn8Vc+nVoOo4C2w6O78VNKQenRyvzFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Khyeg1ah; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Khyeg1ah"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5dcdb56c9d3so10523676a12.0
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Feb 2025 02:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739356547; x=1739961347; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZyGH5VTh11QOnPGsLI8HSOhvGmMGSOYQmxdtjGz5DoY=;
        b=Khyeg1ahRMqgTw17/bTSw11Lota+TUu8IcU4gd3IlvvljnFyQowrs1bmTZcL3X2hND
         jBKqzNJJHO0eGPiH+yD8riQbWoCNslC52i7mVZCge5XIFazoehp7JX87ZLoWzxGB0Y0d
         0a+28XAvvcFb9eidGJUfrYVsdGbo/PbwXtQWHBldVJaEaUugDUvmiiJy+iQze32VehtN
         BfTmtffBukcR0X/vdFhHh7kZOUpq+8Xomsr7eJ12Gm/XpxPKyIKPWKWZ/q6Wd6muGrjl
         V3MqVRv3oiEnfrkAD8RHE8ESojPd2AQoeE5E5TTTPYJiG/jRDGKWMTqT8kEr5wYg749J
         HGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739356547; x=1739961347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZyGH5VTh11QOnPGsLI8HSOhvGmMGSOYQmxdtjGz5DoY=;
        b=sVF6u+p3JU163IpqPE29bgj7KHmlJAtiGdCBiULNOdS4UPsKkUoJtcd+q8xJSXqGdQ
         kMCwdIyXPBFgYe0+/LlaR1ybVrwtlRA/nA++2Bc5ZXidlLU7oYN+QEtsW0Ey+rHYUWN3
         4SCLI/Vd6Wd6OOC3K815YEKxMO8WpSEVISLkghxzH9AcRoQvTewGkApEKzGA1gkGJtpg
         O4oCty2AWEZXtvOhAQSjF2viFdQbLTIXpbd1Mq31A84KTdqQDqpSgN1bEeG/UIsDxczT
         R0Oy9GXqk6IxFtsoqjrDnoLeYIUGGevOHK7aHlOOFsVsZokbzrZK1cDhW4ecD9TqNDcU
         cmrg==
X-Gm-Message-State: AOJu0YwQ+/EkMtYjSBAlhxkK8u6BjpHYnP76uSzVmTC2G1coPDbP46BJ
	hIvRHqh5RAvYfZNPt6TbcsJexy4kgbILuGhY6J32eJtW8f+A0PbZsjjvVbRxrx7gudlQm3/H5Rb
	drKg2GzFqOJppPPlL6MRmbS3vTrk=
X-Gm-Gg: ASbGncuy9oZFIeA1CWO+zz+GwnQfvplck02qJTJXrhQ+5Qw31WhaUijFFUpkJ6cKkk8
	GiZA36CxEhVIX9hAqRAVVupBrbA5FFBoA4j/qCGX6b1ksp9Gaqtur0RSVoLRp+wWl8QwxaTeB
X-Google-Smtp-Source: AGHT+IEjhsz57w3d9912q1gOphJlAPdO+FJkRNU7lpAgOAt1fvavSGY1SLCl66aEMjN02/3wasBpi0yE7haWUTyh/YQ=
X-Received: by 2002:a05:6402:50ca:b0:5dc:71f6:9725 with SMTP id
 4fb4d7f45d1cf-5deadde6803mr4984868a12.27.1739356547058; Wed, 12 Feb 2025
 02:35:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACTE=go+F-ZcynMgGmZTkmEMKw-eoQdD1x8iHacD2c+hebskvQ@mail.gmail.com>
In-Reply-To: <CACTE=go+F-ZcynMgGmZTkmEMKw-eoQdD1x8iHacD2c+hebskvQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 12 Feb 2025 11:35:35 +0100
X-Gm-Features: AWEUYZkOhUAmfiIdgy-9isAzIGmrGT03XoDd5cRbI_gfEj5ya3Rj_DS5H9WjcbA
Message-ID: <CAOQ4uxgYnY3DffCo0qyB3y=rJzgQBKo+dTcLgSwKhgHoMrU_Zw@mail.gmail.com>
Subject: Re: overlayfs doesn't sync from version 6.12
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Haifeng Xu <haifeng.xu@shopee.com>, 
	Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 10:45=E2=80=AFAM Jordi Pujol <jordipujolp@gmail.com=
> wrote:
>
> Hello,
>
> I allways work on a Live system that uses overlayfs, and also remaster
> the pristine filesystem using overlayfs.
> After upgrading kernel to version 6.12 have experienced several
> filesystem problems, thus have compared the overlayfs code of previous
> versions.

Thank you for the report, but we can do very little with the information
"experienced several filesystem problems"
Can you elaborate?

> By intuition, have found that these lines have been removed from
> version 6.11. This difference is key:
>
> overlayfs-sync-upper.patch
> --- linux-6.13.2/fs/overlayfs/super.c
> +++ linux-6.11.11/fs/overlayfs/super.c
> @@ -202,9 +202,15 @@
>   int ret;
>
>   ret =3D ovl_sync_status(ofs);
> -
> - if (ret < 0)
> + /*
> + * We have to always set the err, because the return value isn't
> + * checked in syncfs, and instead indirectly return an error via
> + * the sb's writeback errseq, which VFS inspects after this call.
> + */
> + if (ret < 0) {
> + errseq_set(&sb->s_wb_err, -EIO);
>   return -EIO;
> + }
>
>   if (!ret)
>   return ret;
>
> In latest versions the filesystems work like a charm when applying
> previous patch

Please provide an objective comparison between the behavior of
"filesystem problems" vs. "filesystem work like a charm".

I am assuming that you are using the "volatile" overlayfs feature?
otherwise, unless I am missing something, the removal of code
above should not have had any effect.

The removed code, would have propagate the s_wb_err state from
the upper fs sb to overlayfs sb, but the only code that checks
s_wb_err state is syncfs() should be returning -EIO in this case anyway,
so I am not seeing where the change of behavior you are observing
is coming from.

Are you using a patched kernel or an out of tree filesystem
underneath overlayfs?

Thanks,
Amir.
