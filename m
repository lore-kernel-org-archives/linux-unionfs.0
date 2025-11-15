Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16C57261B
	for <linux-unionfs@vger.kernel.org>; Sat, 15 Nov 2025 08:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763195185; cv=none; b=ukBT0oWF4mm4b1gH2YARaXOw8yMTnOJXwHxfSJjarwIrZ+LJfhFrS+O3Ire8L2zm73KliYcG8sgLbORa4uWblcP7L/fItUXMf7ibp+DIw5L9YmoTmxToglKPeiTM5aSyrYeg9xmNyvYkLOOs+0WYLZgTbAfJIiK9lE56aBaU+pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763195185; c=relaxed/simple;
	bh=B8L+nXkLF5USUX3j1ymwWiuWTqLOWXY3ie0wtNbI01E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LZS0lERHvozLhr+oAN7OqVfakZOmEo25TJ+Ok12TKLByOeBXz+z6pUMixQVbnL2AgF4kD9M3OyUPirEYXJJu+RunKQtLaGVli9V5vjaHdaRYuiTpJnhWfMtWGkGa+IrRHVyCBIrCrkaix7lx8eNAaPhzQpim9GqkL318P5P6YL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T2LoxIyE; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T2LoxIyE"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6431b0a1948so4802291a12.3
        for <linux-unionfs@vger.kernel.org>; Sat, 15 Nov 2025 00:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763195182; x=1763799982; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8L+nXkLF5USUX3j1ymwWiuWTqLOWXY3ie0wtNbI01E=;
        b=T2LoxIyEDFWdXKd4hXauVNC5ZvOmQS1X0xh6qCpnDdt2qwffpxrDeZpb0AJLBhSpi6
         jPj2HOYPIQl3iQIDU5o37QrOA0nCx6oxY+RXcapMHeIdrk5P36dAPOeh2luEi6rWIZ2j
         xiB6VGR4tD80ZSMAsxKehwgGHnEWzOE53twH6V3qjmXaZ/5Q4fmm5OuBw82r478bpcdf
         nn/sq/aljJl/xgTFsNEpvBXQgQWib3w+QtY5M0fJRHkgOCecw/gF0CkYCmlx5DmYDvO5
         nMXCMu3BVjkg/c41eqU/qibDWqf/pV1tqfVw3mNddLwaKROBeRbFTLLYXd3pk/N6q7Mi
         mhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763195182; x=1763799982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B8L+nXkLF5USUX3j1ymwWiuWTqLOWXY3ie0wtNbI01E=;
        b=UCpK60yIwqcP9A8DK5jOXCN/EZ+1QqmC/t4dCiS08Ko4mg4DXd6P5BHNYOHvRLDBEv
         Z+QN0J3ggRQslbOzwQExmHaymrz6b/KYtLrmF5G73QEsdC0UPjxh3QV+He/bTXMLMDxC
         aU/aKMXbc9xH1J2XoM4+N+jrUyBr/rXrn60yjPyCKpaRiEPbNOQToQmTBUQQ30ZDpCQO
         P07zxBUYxHofDwqbT3qY9bdnNQjsvYAfY6JQK9QMRBeiiXO7Pv8wFP7lmDDBAdmUblLW
         zXo0GDmx+iJKF/7YlEf+djvA3Hc9CEpaXhF9095c6l56xddLv+c97RtMK7+stkcXitFP
         0eQA==
X-Forwarded-Encrypted: i=1; AJvYcCXNkvyLpDKEKqenxXpu1c7/8JgT9BclwLpepzNFw9/SzwHyGcGIjwNy5b0q+3sXQlEMiKCdOV/I3MzOdHXl@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrxi+hs/elx+WvDq2Lm+DxvuSgh8b6m5HeS3UrFHeWHvjHBPg7
	slMs8K2/iPexHszmb5ZssnJ39+B1JbPE/LioThHkb5FMglMI/BTXpCRlmz+NIeJi30VxEqPYcdP
	aTuJRAZPuoBIK5SkxbmBWEo47ru9fBKk=
X-Gm-Gg: ASbGncsjJ6kqIVbcmQimSfIerdbJMHecSc0vF814oXWfmeyK4/VAUjCa68Y7llHgs+Z
	yNFbVWUXtmVwUWp7rzz6We8unEORfBGMDLmC+8ukc/T03gNnDOMbrJVKBhIR8uaViGugFAfpuwl
	J2IA/QU9zfNXTSVNazTwqGg7lx0iRPBD1ApGfHjHXKxXBWT5XCPFqtBgoh2xirhE5fdMYIQvvRC
	ZsZiwAqvXi19x783fmy8qKG7sztbTJ6U7iO24rVOBXPOcOa8bz72JVchwHNku+Qi4exkYMi7ipt
	Iz66GtCHCN4KF2caOI0=
X-Google-Smtp-Source: AGHT+IEVA0BWNPAPDyO2G0+1S8lOolkb0M02iLKpeJuAWXeoyvxzpAD7R64zx59hZUe0elru2pwthJW+hFl0/Ql8y5o=
X-Received: by 2002:a17:907:7207:b0:b73:7325:112d with SMTP id
 a640c23a62f3a-b73732513dbmr432940266b.35.1763195182169; Sat, 15 Nov 2025
 00:26:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114-work-ovl-cred-guard-copyup-v1-0-ea3fb15cf427@kernel.org>
In-Reply-To: <20251114-work-ovl-cred-guard-copyup-v1-0-ea3fb15cf427@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 15 Nov 2025 09:26:10 +0100
X-Gm-Features: AWmQ_bmAMd2m3eohHlGgSc4k1bCVh3Z024B1oXoHlA7102uLPC1zCy0VuC1iCzE
Message-ID: <CAOQ4uxgZR6aGvemPFkEGAJ2mop1NJaEQVt-Rr2Cox6zcMmDXfQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] ovl: convert copyup credential override to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 11:45=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> Hey,
>
> This is on top of the other overlayfs cleanup guard work I already sent
> out. This simplifies the copyup specific credential override.
>
> The current code is centered around a helper struct ovl_cu_creds and is
> a bit convoluted. We can simplify this by using a cred guard. This will
> also allow us to remove the helper struct and associated functions.
>

Nice!
Thanks for going the extra mile :)

Feel free to add
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

for this series as well.

Thanks,
Amir.
