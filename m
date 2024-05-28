Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C8716D4EB
	for <linux-unionfs@vger.kernel.org>; Tue, 28 May 2024 12:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716899201; cv=none; b=JEw0oOrUPtt5m3UJLUE07IZN/AZAMe8rTkHT382nf1lLHOfuTPvpZ8Ti3ASKoiu3Rf/AopcLeYR7o/8/i/Phe4hDm48mwo69SPzWmbldiyHtDUEVhFTFNkacdsrdq43bEciZ2qbCWrC/ctPmSo7HnANPLoRT2Ggn5ZEBCn0dfRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716899201; c=relaxed/simple;
	bh=q7jyQ90CDbKjDFVOMbX7rUGfXAM/w2kLEYKvfcuzvWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rYVMFdqhmJHoXwaO5gExfkJNBUUkUekbtCr4mwF9zdHuR2kMtLLVedVTy9GlFNe5677An8sD1GLaqY56Y8r0zF14Mua43mHhHJct7csiX19Kc4Qe7+zqSmr9iqrJUmEIi2dNCaeB/d0ud37YGp5Crd4F39WljMjYQmmQo02DBMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ya9o9XQV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ya9o9XQV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716899198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZXftqT8nCmYhEAaMlOtfkkpZWNhGkvnCDmr6/EFeHBo=;
	b=Ya9o9XQVVwaqHYwBrJHERGJWiYCOwpkFlv1HakeJzrMHptEDv7xRzfdWZ5W2jTb1PX2qdp
	hz1jqszGK5HFx1uDeKtbK8NcbZadBt85JMqtFiNtLMXfCb3r5jZSoSPcRSud3xiB5cMRyJ
	WXbstKKMnhnxIG5kJIN8kB1J/WyJL8c=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-tmj6paoFPc-2leBmQtoayw-1; Tue, 28 May 2024 08:26:36 -0400
X-MC-Unique: tmj6paoFPc-2leBmQtoayw-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-6658818ad5eso701499a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 28 May 2024 05:26:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716899196; x=1717503996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZXftqT8nCmYhEAaMlOtfkkpZWNhGkvnCDmr6/EFeHBo=;
        b=s56rVCfKMWtDuDdhQzILcsBTN7TuCaWO8zK4+F8xt8VdtFz8WsuA2gM4QwCEwRKoTa
         zPEWbmJ4tw3i8lFzECkQvnNebuU39EN556GDAQOnMQtYkqluifiip3zub8ITH+PYSluS
         lvhQ7MRwW2ENT1JCHh6mptEZHv8+5B4S3/MNWMIP/1PQ2hv1D7zALH7eV/jOmrYu/YzC
         zUlZpsWv+cUrfJ8PV5dTUCKDcW0CyYDrDCiYfu9EbQr9bbDRFO7nbq24w92lygrBuupt
         8sjU0xJZM+YtvzSZPSy+/hIah7UVRtXOhGqMz2Q1SjoMt+pbrQzVxbX+l1ZGhfEai886
         xiPw==
X-Forwarded-Encrypted: i=1; AJvYcCXcB7GSFI/2lxcrbJHJmopEMMBkFNDuzdcndCl9I7eP5Z2Uwd0c1a7QkgGcdoOb6T0Ep+s71vbU1RjgMGm+WnuSqOY2KGcyZ8JoWa1gIQ==
X-Gm-Message-State: AOJu0YwOtFuktkZBJAgZCLMrDf4RzKEBIC+0hjx4536wV/Qzx9pcjbiy
	h2jVBTGVsyc6VYs3LVg2YuBDJg8n8G2a7DY7f/r1Dbc2Yju64mSqEMFnuRnvHpAv1BRujDYpxpV
	u8IwjGhrUTCBOzgM4nK8kFFtyZnupDf9POhao9d/LWfVn8+usBOi7JXkz5AQjuxDvk0YlrAWQJy
	O2Tvznkc/RjSosEl69g0XkTfG1aGjht9QNjc4+Yw==
X-Received: by 2002:a17:90b:120e:b0:2bd:ebd5:8bf5 with SMTP id 98e67ed59e1d1-2bf5f207c7cmr9892304a91.32.1716899195768;
        Tue, 28 May 2024 05:26:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnILb8oyVRwey22n3VxpJpZdj/JuBx4Cip4MEcNZcih+aIp+8+qLH1y0azOTTP7yl0A47rV3aFPZjtYcwbU/c=
X-Received: by 2002:a17:90b:120e:b0:2bd:ebd5:8bf5 with SMTP id
 98e67ed59e1d1-2bf5f207c7cmr9892286a91.32.1716899195378; Tue, 28 May 2024
 05:26:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528090244.6746-1-ecurtin@redhat.com> <CAJfpegvoao1jd7HhoPEeWCdS8jWEXhKTENbwvLdo=aMiNaLKQQ@mail.gmail.com>
 <CAOgh=FyHFE7qjfYq4BqGc20SYJ5FebhN2iYpJSsYYatO1TkqBw@mail.gmail.com>
 <CAJfpegu+z2Nxvk2H9vfZ3nfzEEixUG4kEthVGHWUYw0wX5bgMg@mail.gmail.com> <CAL7ro1Hm7EOxKUv9U5vEMbe2Ui2oaCdM0b2Xbm0wbdZ52+JV2w@mail.gmail.com>
In-Reply-To: <CAL7ro1Hm7EOxKUv9U5vEMbe2Ui2oaCdM0b2Xbm0wbdZ52+JV2w@mail.gmail.com>
From: Eric Curtin <ecurtin@redhat.com>
Date: Tue, 28 May 2024 13:25:59 +0100
Message-ID: <CAOgh=FygeLw0jBLvPKiaBCxKkfoQXmwf=sfvyJHs4Hyy_7wDSw@mail.gmail.com>
Subject: Re: [PATCH] ovl: change error message to info for empty lowerdir
To: Alexander Larsson <alexl@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	"open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>, Wei Wang <weiwang@redhat.com>, 
	Amir Goldstein <amir73il@gmail.com>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 28 May 2024 at 13:23, Alexander Larsson <alexl@redhat.com> wrote:
>
>
>
> On Tue, May 28, 2024 at 1:34=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
>>
>> On Tue, 28 May 2024 at 12:55, Eric Curtin <ecurtin@redhat.com> wrote:
>> >
>> > On Tue, 28 May 2024 at 11:34, Miklos Szeredi <miklos@szeredi.hu> wrote=
:
>> > >
>> > > On Tue, 28 May 2024 at 11:03, Eric Curtin <ecurtin@redhat.com> wrote=
:
>> > > >
>> > > > In some deployments, an empty lowerdir is not considered an error.
>> > >
>> > > I don't think this can be triggered in upstream kernel and can be
>> > > removed completely.
>> >
>> > True... Just switched to Fedora Rawhide and instead we just see this o=
ne:
>> >
>> > pr_err("cannot append lower layer");
>> >
>> > >
>> > > Or do you have a reproducer?
>> >
>> > Run one of these vms:
>> >
>> > https://github.com/osbuild/bootc-image-builder
>>
>> Apparently it is using the legacy lowerdir append mode
>> "lowerdir=3D:foo".  This works only on 6.5.
>>
>> In 6.6 and later the same can be achieved with "lowerdir+=3Dfoo".
>>
>> It's strange that there are not side effects other then the error messag=
e.
>
>
> The code tries to use the new mode, but then falls back on ENOSYS:
>
> https://github.com/containers/composefs/blob/main/libcomposefs/lcfs-mount=
.c#L431
>
> So, I guess with a more recent kernel it will not print the warning.
>
> --
> =3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
>  Alexander Larsson                                Red Hat, Inc
>        alexl@redhat.com         alexander.larsson@gmail.com

I realized I never posted the version of the kernel producing this
error message:

pr_err("cannot append lower layer");

So just for clarity in general, that was this one:

Linux fedora 6.9.0-64.fc41.x86_64 #1 SMP PREEMPT_DYNAMIC Mon May 13
11:58:46 UTC 2024 x86_64 GNU/Linux

Is mise le meas/Regards,

Eric Curtin

