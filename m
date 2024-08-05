Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6982214F9E6;
	Mon,  5 Aug 2024 21:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722893413; cv=none; b=fiq6ucEcWKjvoLDQ+l8f4ZHuuaLSD5YwDyMSKfOSeI2TDBwzUBwLcvsZeDvBJZ6xsC6HWJEOZKwoGYqql00jrVbWTMq4i+4h1sKX0aeJSzsiLJo5HjEbCc6vbVoIfHKs0+fsYtzyRsex6BIBB/zDcjbhb6pjioWfpeQJZb9Jj9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722893413; c=relaxed/simple;
	bh=NfUJkO/2I6MkbJVm3rQsZ2yzf8gMREpnlgWazi1MmEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=thI9cKpaNcQh744DBHZTqI1XE6slfbZF7ym+qHCv5ikiHPAFRLugAVq57ltMLiH089qSgm9FzZDbDSqeQ9YM1i8zQzplDthAFbnXFIKqZ6oA6AvLPqYjAwULC7NrQE9daieoMSrdo1sOWFsMZqGM1DEZbxQyaGjcyVJX3ksOgRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jSiv7Ht8; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jSiv7Ht8"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4f527c0c959so11631e0c.1;
        Mon, 05 Aug 2024 14:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722893411; x=1723498211; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hwKcqnIeZGeHTOMCr7wCkv9rvEMAJ26PnYCpuDDqoQ=;
        b=jSiv7Ht8q6LD7fvl4Nc969XkgjNIhRhkWYGUlwOUbDkCJUmJeEQT/aqpkRHP+LhivU
         +sDcoVS1y/Jzh53f1biwo3WyltjeyH8wUywUUsYr+BNF9F5hY+C/zPXvp9zMHbjuQoax
         OLHmJ5cSHbcRi2bDtR3w/NTYrqlrNBdRVR/8NLdFFJsjbtvxcRQRbL/DvfZYh2vVwB7p
         K3q5UQD6Qzh2X++lfbXiD863GryocjJzMJE6d9gMOueYdRnbft6OkMbFzztRxIk+vSHy
         IObAaXF+ZJmlClEmU2ZSj1tt5qC8I+2l5JNmBGdRnaSOYsM7w0MILh+BPZ3xr8TPoe4G
         Oqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722893411; x=1723498211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7hwKcqnIeZGeHTOMCr7wCkv9rvEMAJ26PnYCpuDDqoQ=;
        b=UVbyEs9PeiUwGzQMhvhuDDXHQAZJF3zxCWXPyMxPlnB8enHMCJs4wwZgzcf5jmXOiH
         umJnjGjUo4/HFAawk26GRGhrf8GmAsQC9iop8b8PaMKfmlueyx5uohydDfAhbkmLErnO
         9PCA1w4KBZEiSEJ9tpu3hLv8w0MTdXx+blIpNSvzprZ+1diPE89X1aCNArJ8RESl97++
         DJCz7+8jBg7gbpxp7U5Fh7gQLdaHHO56SrsI+Pl9fcOyV5+mwvfafJkOW0Ext0JOi/VV
         CkiLa8hFZMk92pQEFomB2PlY1SBpTcD+PiGydmLiuPAX27kBCsdvH4CO9t4ThYA8Ts9w
         EQLA==
X-Forwarded-Encrypted: i=1; AJvYcCU9plg/LIh3zgRq7wK2MfIizOjd5pNMbECs0gEFkj8ghbPhj6M9TWUrMwffmd1mXZFTjfDkHVg5V7QzivlxQZQ/23t2hSdNGQBH
X-Gm-Message-State: AOJu0YzlMQWzzKVFM78tnibH9lLbDk0zxce5oYcCfDH7OuPoem9pZ5Ie
	zKzJZpKBmPCLVANi0xecppyYM1pdXISYNPzpsRXLfbTOrmoH++u4TAc459faqNdpIFSjF4aYfXe
	A+0yADuG7OxyPKIbJJ377fWXsPX4=
X-Google-Smtp-Source: AGHT+IFsrqYArL8lD0hsbQZBbDeOSeqsPxTrMV4umHHV7MPiDZhcGtLGtlWxfydz2R5F/Q2u396/3C9z+8wbzgXIHeU=
X-Received: by 2002:a05:6122:91f:b0:4ef:5e6b:98c0 with SMTP id
 71dfb90a1353d-4f8a001105emr15132638e0c.9.1722893411019; Mon, 05 Aug 2024
 14:30:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5BB255FB-6370-40F8-B5FF-B4B09887C903@gmail.com>
In-Reply-To: <5BB255FB-6370-40F8-B5FF-B4B09887C903@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 5 Aug 2024 23:29:59 +0200
Message-ID: <CAOQ4uxikxHiiEsF_9HngKrjYEyZuhE-Hp9DgVhQGHfGPmCY__w@mail.gmail.com>
Subject: Re: Documentation contribution guidelines and suggestions?
To: Yuriy Belikov <yuriybelikov1@gmail.com>
Cc: linux-unionfs@vger.kernel.org, 
	Linux Documentation <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 5, 2024 at 11:58=E2=80=AFAM Yuriy Belikov <yuriybelikov1@gmail.=
com> wrote:
>
> Greetings
>
> I am a student intern in CERN and currently work on Overlay FS related im=
provements in CERNVM-FS project (cvmfs repo on Github).
> I want to expand the documentation for Overlay FS by adding a paragraph t=
o redirect_dir passage with an explanation to which values the attribute co=
uld be set by a system in cases of merely renaming a directory and moving a=
 directory to a different directories subtree. As
> well I want to add a bit of details to metacopy option description regard=
ing files that are landed in the upper level directory with this feature be=
ing turned on after metadata modification.

Sounds good.


>  Are there any nuances that I should read about contributing to documenta=
tion on top of the linux kernel doc-guide? I have never contributed to linu=
x repo before and just want to clarify.
>
>

Just follow the "submitting patches" guidelines and you should be fine.
If there are any other requirements for documentation patches, besides
that they should be in valid ReST format, I am not aware of those.

Thanks,
Amir.
