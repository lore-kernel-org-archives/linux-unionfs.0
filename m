Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E765E39859
	for <linux-unionfs@vger.kernel.org>; Thu, 22 Feb 2024 10:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708598346; cv=none; b=GDUzLtAMzKMSOvW8iu+8HXvfqZJo7OIg0Me05UfAPsMXAxW1MwdOV3g968LEeLC1kBtpEn4zlFjWQXUvPEqrME+fwdus+hkYS0xLZGdl6X76BKNI4mw9jWWU6wKJ4NNwKbBud7FC7HgF1n2jI+u/CTXZroFtGR2Hfy+n+XuO8dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708598346; c=relaxed/simple;
	bh=AKORqv8uFNp+okBNkTZVz8Y5eevlILbT2u63pny6Q6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ABsCrhpfBtcuC5pAuTY89wKD+aJlBZj7mOlBnz38tttLoRoGErgOQW7DxyGz1I6HhT8YHcTsYgad5ob5OTqHuFXXTfSK2ttR37dqZx86FN7Va5zR/QiWU0genAfSgQlxycY+RmlcF5trP7f9E6RhCorEku/vSFrq32Mu9LA9FOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=GZoO4p9I; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="GZoO4p9I"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a293f2280c7so1103457866b.1
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Feb 2024 02:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1708598343; x=1709203143; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AKORqv8uFNp+okBNkTZVz8Y5eevlILbT2u63pny6Q6E=;
        b=GZoO4p9IFr0ggbd6sNm3OCaKg/VmSLhUylMIDZUW31oIqntkTmtWPSvPjBpRX55h1C
         AScevPkF3XW6EnI/X3NW0jTXlMlxn98aEvzVL3tfPyXWOq2791vr+QhoVAwW4nI2Vh10
         I4ii0s6LVTOw+BhbTBUMngpiEaiq98eoOLd/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708598343; x=1709203143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AKORqv8uFNp+okBNkTZVz8Y5eevlILbT2u63pny6Q6E=;
        b=V7H3MrKZ/8awvCwUMRh4Oo6R9ugFCfVL1gtZuIIeRHMTq0m6cBGm4tdcoSXwRdNpZt
         kJwLzJLNhVpRcRuuv+eklzXM8T740o1E2pFsWdiAgXpNhj73pKIohzW1IB48+wEZ2j7j
         +GSs8Uk3fAH9k4u4SRiptB/CR5JNwQFu/Pfkz2df4v6j/hyE9nRawlDKUaSCzlBja1lR
         eYYwiK/cLgF3MsANvcyWSE9ObIuTkvHBrBXn/HBSrsWR/rhSPoNRSyGzfZwE1URld8Gz
         w42SFZXUfcOPArwnGrDG29ZRFEH+GN2sZ/sStopecolluiDsBsDFGNdMqweaciC462gh
         7ltQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzNlZSrgtZQeUGTX6VFfFNG0+c1i86IBaOncLM18co38EqfSGh4pCGo+cKs6brW5VXFiH9mcL1pNfLg06trOBmIxxiqdgkk+R5tzs/jw==
X-Gm-Message-State: AOJu0YzrJKPd3GzSd/CabB5C/SEJPk+tG6LDHlmPyqahql26tq5pNhvI
	29TVv15ewa5sKvbXBe7LittYPZYOZ9J9YuOW6kWT0+wwPPCKPf7g65C0h2LhkUpXiYf/wMM6PAe
	MojsX3DLOhxDCquzKDk8RfgXB+cYg63s5o4Ds6Q==
X-Google-Smtp-Source: AGHT+IGnw+g+0BUGCkHQr/7kiZQogN6Z44c5Vh/mJARPE1yJHykMkt9Pr8GSPIdn4HhOwkPjIaMGYnootKRLuyXawlo=
X-Received: by 2002:a17:906:1d55:b0:a3d:d1da:1247 with SMTP id
 o21-20020a1709061d5500b00a3dd1da1247mr11797802ejh.56.1708598343308; Thu, 22
 Feb 2024 02:39:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67bb0571-a6e0-44ea-9ab6-91c267d0642f@gmail.com>
 <20240222-verflachen-flutlicht-955cd64306f8@brauner> <a0e19bdd-15b0-4b90-b27c-26ba52a72135@gmail.com>
In-Reply-To: <a0e19bdd-15b0-4b90-b27c-26ba52a72135@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Feb 2024 11:38:52 +0100
Message-ID: <CAJfpegs+wH8NNqc6E-D0teBjc8yj_2uM6Otykcz-PJtj0MpjQw@mail.gmail.com>
Subject: Re: Can overlayfs follow mounts in lowerdir?
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Vivek Goyal <vgoyal@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, 
	Luiz Angelo Daros de Luca <luizluca@gmail.com>, Enrico Mioso <mrkiko.rs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Feb 2024 at 11:34, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wr=
ote:

> Can I bind mount /tmp/ to my temporary virtual root and still make use
> or overlay to don't touch underlaying system?

You can bind mount read-only, or you can create a separate overlay.
For /proc and /sys the only option is a r/o bind.

Thanks,
Miklos
