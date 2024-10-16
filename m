Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B300220694F
	for <linux-unionfs@vger.kernel.org>; Wed, 16 Oct 2024 11:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729076969; cv=none; b=SFfubFxd5t0NfOzgj/I7hPCa+7Fh/uWP/0pIfVYt14CC2p7sBvWQ/SeIrwbD/IBUBq9TJ2I6AqFJrXDG1QAGhlXHNHe/5MioE40Rai/Weo9XgVV5/IhvsxbO75FBzGgUt6RZMSsdzHf5DkY+rOYU3q2V6pDxpKEXW+hIlLWQtA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729076969; c=relaxed/simple;
	bh=8gP92A+Ze+n24rBoK52XoGxxw396/VWsU0nZSEiSWIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sdFfi7krcMgHlVplM1gV7UMpvxKZhhOIywsngntMOzZuIxPVMOupQFnjcfKxnsq7eabof8G8YYQTILak6ulwbNzvWeJRoe+Ts9hdMuAZZzsWz3AZKpADMTmqxFn2a6YAaArvM/97l+i/Xi6N4kR1d7mf1Ah5iyWB1b7q+wfgssA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=nvUZ0obm; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="nvUZ0obm"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a7aa086b077so829908166b.0
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Oct 2024 04:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1729076966; x=1729681766; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8gP92A+Ze+n24rBoK52XoGxxw396/VWsU0nZSEiSWIg=;
        b=nvUZ0obmN4qrFWl71705BwraG/5BdaWz7Y2HH+iqUDJUc21hV6B9UUR1FIRiM9QFLz
         d3MxQX2qFgDRCBRt2zpNfihlH6RpFvsnoFnDj/6f25F1HwzsqjRCLJcP+cIUvtPlJKTb
         XzCSGsQpfQZ7SGkF0aXIWmP54vTaJkas+y2dw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729076966; x=1729681766;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8gP92A+Ze+n24rBoK52XoGxxw396/VWsU0nZSEiSWIg=;
        b=E7npVnIWc0GmJrqrHBumPgylbRkCJUbA8PTdM1K6SNOmMyrwZHwQKGg3MRqZfMPXAR
         iHZzp11WcpDHkYbDtyPD0Bp7E2w8CpyEx7mWJZCSMpkQrS+Nv+09xMqvQr+H6o/8v+D1
         D9BUKjUGwesV0ZJthPeeYmwvtaoQqI488/DgKDjSzFICEo6oE3+RsXM1th3hqmgHCpq6
         +HSgGKOEDrJ+odfV2WnllOK15z6kQrOaJruMIUuEFECuzDtj0+TXyS8VMgeXsHOkZdk+
         7HR/VGFfD/Er8gHlrNujEj1JRwQ/61JhdSKAnb8uhp8TT3kucRnV+qSgp6Nk+luXGxER
         CO3g==
X-Forwarded-Encrypted: i=1; AJvYcCVo4CRvnn+zzrBw9z21y5MatEwjWLfnnSsWtBB5fLJ874tc7NQtX1c6BpGPtgfEFlezeXOrgH5fOtg7FTdR@vger.kernel.org
X-Gm-Message-State: AOJu0YwRWIgZN6zASDk/kLB7uHrrKU+K72pUxaZRuyvsxMc+s9aIDibf
	m74WU9J7HdIaeQfOs7KttLz7/IGoY7a/Aq3R/MYSW4hMjgOvMNTUN+m8T12MfCLTc0nRf9E2IuJ
	7GLlvrNbF6X54T3OU4m716K0zcrVGvDQ4UNROrg==
X-Google-Smtp-Source: AGHT+IEBWK43pEuSVPY5kfHUSC1ctgBijgdwpK1K66HvvMpx96cAtgZ0O0oJMCEPtTEDN0Fi58hIKlah5t26W53KDfY=
X-Received: by 2002:a17:907:74b:b0:a9a:222f:45bb with SMTP id
 a640c23a62f3a-a9a222f495bmr682124866b.35.1729076966086; Wed, 16 Oct 2024
 04:09:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202410161847.oG293ywD-lkp@intel.com> <CAOQ4uxhD1QYnZHRekQPm-A+3SFXMzv3vZW6r59kSOFAtXNWHEA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhD1QYnZHRekQPm-A+3SFXMzv3vZW6r59kSOFAtXNWHEA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 16 Oct 2024 13:09:13 +0200
Message-ID: <CAJfpegvecwzi4FccCaVc-UFhRD88evWEFqe8S_DqMBwSePHXGg@mail.gmail.com>
Subject: Re: [linux-next:master 4258/4954] fs/overlayfs/file.c:234:57:
 warning: omitting the parameter name in a function definition is a C23 extension
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, overlayfs <linux-unionfs@vger.kernel.org>, 
	Christian Brauner <brauner@kernel.org>, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 16 Oct 2024 at 12:41, Amir Goldstein <amir73il@gmail.com> wrote:

> Preferably also the fuse_passthrough_end_write() function in the
> first patch, so there is no build warning mid series.

Fixed.

Thanks,
Miklos
