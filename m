Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA922D0C76
	for <linux-unionfs@vger.kernel.org>; Thu, 30 Oct 2025 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761845145; cv=none; b=Ay/yBTmDQw8b8Z23MNOtLDMJE4t4rXrde0K8e2cvs62swHsBC8C3LZtLfgLfzMnDXasuI42CQ7l4fehr2Q459/ZkWvnEDkUvIfTtjzXmKNLaWeAU9NLn1NxFtlTmzjuOIL8K/I8YYlGOnqYSWcKbhxdWas0p3dHde28qi6mAiuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761845145; c=relaxed/simple;
	bh=9CSkgeRmjxnffdqxAfUWjkOq5Co09RElA3omchynSgo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=AcF0YkHx7+/HvUDEPanu11BBWmfz+5fgmu2ptkj98F70WUQPqejUfD99dXwo07gdjDi4dQN+IvH4NxbKhsUSE3L1yJRmaNJUyMjzXWBtmOLJ56itMJoDEYloJ6BcrZ7R6T1IuyGr0v+B3f9eZsHXqLiJlxKaVHzuFqDH7063Gn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lunarenergy.com; spf=pass smtp.mailfrom=lunarenergy.com; dkim=pass (2048-bit key) header.d=lunarenergy.com header.i=@lunarenergy.com header.b=kNrL4Sa8; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lunarenergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunarenergy.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lunarenergy.com header.i=@lunarenergy.com header.b="kNrL4Sa8"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-475dd559b0bso17630425e9.1
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Oct 2025 10:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lunarenergy.com; s=google; t=1761845139; x=1762449939; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MtdUUk46gvC0BTXH+7ZO9rPv+1ru++xGD6Msvr/MHPs=;
        b=kNrL4Sa8p0hBj85YTwPsBdd59mfVvG0zxzEWKJislOUu8rGwl/j+FJ2gW+DQrKASeu
         Y2cKd2eEquO+gQQ6Z8uXBBtOKP0jxYWJ9lBfBGKFSf+8yTlHPYWUKsw+OHrKZehSI2lw
         /BjZM1+/Ux2kZmBBJBzguvBVSy8MM9qD8VZqgC240MBPQges26AHw862Om1tMU/7cT2t
         CtFEiOOU0bzz71hyKKOd5TeVDGYybpru/ZIIJbZiBIWUiBwHr4uEnalHL1D9PFmn9gVK
         +mtE1quGRHYnm9ZV8eDTe8MAh8Ckm3F8chYRdQIO2jXzUrz2nAezwZ6NNXICDy1vMDqG
         3/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761845139; x=1762449939;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MtdUUk46gvC0BTXH+7ZO9rPv+1ru++xGD6Msvr/MHPs=;
        b=I/TrMizh+StzoYppR/ZRiZgXNEuvuvGJ30H4z5j1lLWQLAvtrViQKeTs3x4mxRj/xC
         Irq7yJ/E5e10nssPoCY4KI9DtTMtKOVf5MzGd/3mHAge7oEnod7gRi+WjAhAVg7aJTvI
         wtD+0HYM2s1pwyF1wfGQKzXf6wLOF9nmSkzwCaXakIW/Th/lwZN7ZlEDvXEE2iWC9OlN
         H8ybARGZTCntgIxMn3wp9rJe9Cy7X6S5g9OdZJSqx9hte16BrivSgWKWe5fO0dz67PNi
         An+1g6z6q0OTjtOz9sNgjmOci0arnllQ4c54v9poeNBy+LD8jyXS3sVUWOSye2kS8wDU
         ZX3Q==
X-Gm-Message-State: AOJu0YyXAzupS8+27kIGx2zEXk/kAzR/ck/5wd0UB58aNlNycakU5DQh
	gLI9e0OU+b/8vKmXjlNJeD1IUbetfdJo6VIAhnIHpQq8viXrXLIMYYVtCT0/j9mpOYbsXdzZDzD
	7+SFArSt/wUrFlc6ZIkgxJYMlWNMu54BwbfXX+gvISAV0HicK7fFgITps0DpknsKVrmC3BbIUJe
	14eaEGvVl1kxtTIXCsgB/66s/iQzHRSUa6T6Ju9i38xbXLG6dJ
X-Gm-Gg: ASbGnctVgogGLUtE7wANx3+HXV38hq2M4T8kCE6Ocpag3bJ3n7aN3TiUsca3A691Esw
	Qx+Hfsnc3Zc1SwX13dkB9DlbMurSz1zVSCTn4HxDoa/br5hVWGw3ks7O+zAuORRZwGumXbEB/Z0
	71no1S0JnIFUsfoPIm+7kRf9gKLf7wbwT4obj+VTArZq7OK3TrGjxNDxvXgX/Z/M4mr+TACf9gc
	2fFD6+1CSKDN5cbon3Bt5IjiHRpnNV8UCpKAuU3pE9qJ5LjYTeIEsyOwMn2ReqVRuF622s=
X-Google-Smtp-Source: AGHT+IEJqgNlNxus/uYz+tHnU/pPr/vt6xI84X9/0AfvwxT4xek7aygHGehDqndLICQddT/3Jidcyvh99nFj3fRLTn8=
X-Received: by 2002:a05:600c:8418:b0:475:df91:de03 with SMTP id
 5b1f17b1804b1-477308ec666mr4582085e9.39.1761845139066; Thu, 30 Oct 2025
 10:25:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Mark Corbin <mcorbin@lunarenergy.com>
Date: Thu, 30 Oct 2025 17:25:26 +0000
X-Gm-Features: AWmQ_bmB4rv-BOVVfvlIo19H_iECCZ4Zo0-_gw233T621Ed1RT37UdBiEC_EUe8
Message-ID: <CAPfD7wmf=ks9WEgAKdLWsn1igWG+v4bYsM=+ATat_0BZ+djaOA@mail.gmail.com>
Subject: overlayfs - vaild to mount mergedir over lowerdir?
To: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello

Is it valid/safe to mount an overlayfs mergedir over the lowerdir?

The Yocto/OE mount-copybind script does exactly that:

overlay on /srv type overlay
(rw,relatime,lowerdir=3D/srv,upperdir=3D/var/volatile/srv,workdir=3D/var/vo=
la
tile/.srv-work)

I wanted to do something similar with a read-only /etc where the
merged /etc is mounted on /etc, e.g.
mount -v -t overlay overlay -o
lowerdir=3D/etc,upperdir=3D/data/etc,workdir=3D/data/etc-work /etc

Any issues or recommendations?

Thanks

Mark
--=20

Mark Corbin
Senior Software Engineer  |  lunarenergy.com  |  LinkedIn  |  Instagram

--=20
C2:Restricted unless otherwise stated.

--=20








Lunar Energy Limited is a company registered in England and Wales,=C2=A0
authorised and regulated by the Financial Conduct Authority under reference=
=20
number 767876. Company registration number: 05631091. Registered office: 55=
=20
Baker Street, London, England, W1U 7EU
