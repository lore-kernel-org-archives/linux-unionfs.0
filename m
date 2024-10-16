Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FB01DE3C9
	for <linux-unionfs@vger.kernel.org>; Wed, 16 Oct 2024 10:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729075258; cv=none; b=LcgzvvuEVqewpCm2MacHA/00ADYSpR+RTl/nPfEZT3YbW4IlGngS6K1iYrF79h+M/+1JSiGD0Va4vPeBDFc3vixHr9yJX1SjTL74wWm7c+pAz32dqnZ6l/pofiwVDlbDWmW2lgE4HZKt8a1tY2dJ0sC4Y+ZcPc8IYgYokbcy14c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729075258; c=relaxed/simple;
	bh=Mll0mPwF2ihobJp02zCEgEgBwbqhStJkbk5l1xAiSII=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K/vnLvv1v0x/XQ2fiZOYhy7mYT5a1tyroNyi9vNXjqcYp2xb5w/Jy5KfvJMFlCw7urX3ThP/YQhuyVrSaJ3EYK2x1+R+ihG+haU3NPvNlSnBN3kmZ6j1Gd2j2YBdIQhQiQKVQQg2f9D8usvAH6libQmRN+KxfgjccdA7HER1ih8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ol9ylT0p; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ol9ylT0p"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7b1363c7977so167161485a.1
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Oct 2024 03:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729075256; x=1729680056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2i3NqB8GxXUWyeepDjFITep28fiJMthRR7FM+yUWlU=;
        b=Ol9ylT0pxCnGNmR+9QyAN2//p6S5+IFtfLG9uFf8fluASSOMRef30CumWDo4kkpQJY
         wQ/aB9YoSgI50/HIG0HxRGjOlwimLSWBMMcoSxhO9s6guOPV0vvObmtpOm18XckDkloM
         hVxiHzaCEf2R6P9d9XuAYR4MLfmYrRfTliBRKfPsHB40XmtqF+c8ECvrmWyMtDTYvMhK
         nxIvNc6SOCPhcrKz81z5Gck49gYSQU+SUL5WDcuKvifdLamatzGQUeTN3eHWvH85ZXik
         QORiqMAyXAf5iP28QHtStQn+xcgZMHBL0R1ftTsIB3/RNYVlhK8sn7chyuKUHfvcnLjt
         Ye+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729075256; x=1729680056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R2i3NqB8GxXUWyeepDjFITep28fiJMthRR7FM+yUWlU=;
        b=NxxyqL3CuHzW6/QRbKc1xSPdnERNIPsmUHwzjnUEKM1h2rEZm71RsLn5U83a5swPBz
         3uo1BLh4WXAOmRBqRfIXOuPWzldGATn9K34MmQf0Woxr1P0mdA5MlLof2+qYtJgKDiUZ
         U2vYQ7y8PN9FEn+kxib2jxOsugAyyGtqPDDv/4JhNw39KiNPJesRoKjTOPcrC/s2KhIs
         3nLh1oZz1zPcvvuDaRl5QrllzThBAEjW2i026R/YluliDH82y/pO/+Jyu9u8IBOo2weu
         NUiUH+xsRbg6nD/vjXxPEKqpn+/dgrHxanZl8Ggrnu9WfUZGqZSWSj6GHfQ3VKw+V7uL
         zfiw==
X-Forwarded-Encrypted: i=1; AJvYcCU/EaGGPZH5Z8PiDWIEH0KlTSNPT4y/Rpw2RhddY4j5f2WHZRQR+bsvYx94f1xYOHevCYSMYmGk3ib7iU0e@vger.kernel.org
X-Gm-Message-State: AOJu0YyjNakrx7sZeqZPd83Ate4plyTwytCflQ0uvq5Dcn14OKtAglE4
	NY0/czKxGEJt8rY85PNm4AoErSddKR55xj+evkI2WoMeFpmvWq3En7vkp+tRwwumfrCayiSRXxn
	qVHqHTiTClbMwSdX12fT8hvM7Xgw=
X-Google-Smtp-Source: AGHT+IGTOksWfLUuL/KlW8e1i77FBbNWUSXq42QyFXKEgMd4+5AZ7TTP1Zc+zXzUawuRmsGyXou5G5XjrdI+fDdUqHI=
X-Received: by 2002:a05:620a:24cb:b0:7b1:3b99:de1b with SMTP id
 af79cd13be357-7b1418a039fmr486277585a.61.1729075255775; Wed, 16 Oct 2024
 03:40:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202410161847.oG293ywD-lkp@intel.com>
In-Reply-To: <202410161847.oG293ywD-lkp@intel.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 16 Oct 2024 12:40:44 +0200
Message-ID: <CAOQ4uxhD1QYnZHRekQPm-A+3SFXMzv3vZW6r59kSOFAtXNWHEA@mail.gmail.com>
Subject: Re: [linux-next:master 4258/4954] fs/overlayfs/file.c:234:57:
 warning: omitting the parameter name in a function definition is a C23 extension
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	overlayfs <linux-unionfs@vger.kernel.org>, Christian Brauner <brauner@kernel.org>, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2024 at 12:29=E2=80=AFPM kernel test robot <lkp@intel.com> =
wrote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.g=
it master
> head:   15e7d45e786a62a211dd0098fee7c57f84f8c681
> commit: 291f180e5929ec636ecffd8a0bba00da907e0f89 [4258/4954] fs: pass off=
set and result to backing_file end_write() callback
> config: i386-buildonly-randconfig-001-20241016 (https://download.01.org/0=
day-ci/archive/20241016/202410161847.oG293ywD-lkp@intel.com/config)
> compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b=
5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20241016/202410161847.oG293ywD-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202410161847.oG293ywD-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
> >> fs/overlayfs/file.c:234:57: warning: omitting the parameter name in a =
function definition is a C23 extension [-Wc23-extensions]
>      234 | static void ovl_file_end_write(struct file *file, loff_t, ssiz=
e_t)
>          |                                                         ^
>    fs/overlayfs/file.c:234:66: warning: omitting the parameter name in a =
function definition is a C23 extension [-Wc23-extensions]
>      234 | static void ovl_file_end_write(struct file *file, loff_t, ssiz=
e_t)
>          |                                                               =
   ^
>    2 warnings generated.
>
>
> vim +234 fs/overlayfs/file.c
>
>    233
>  > 234  static void ovl_file_end_write(struct file *file, loff_t, ssize_t=
)
>    235  {
>    236          ovl_file_modified(file);
>    237  }
>    238
>

Miklos,

Could you fix that in your branch?
Preferably also the fuse_passthrough_end_write() function in the
first patch, so there is no build warning mid series.

Thanks,
Amir.
