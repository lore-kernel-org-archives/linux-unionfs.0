Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F5D19ABD8
	for <linux-unionfs@vger.kernel.org>; Fri, 12 Sep 2025 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757691154; cv=none; b=LgI91JPf2S/rUU3G7mPSSRmZZmXOz7Aa+x8eWRxKrlNBkTX6v589f781oPB+8UFYWLcpzSQSYRoWRgcWN+IDrYyBofm7/LVYrue5HrpUJaSaDCRnBFRw/0yDC4VBLOFi+pZAIfRA25GCbRs2xYczMTb5Vz4cRAosXt4r1Nsj5G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757691154; c=relaxed/simple;
	bh=SLQ7ShI3cjyhcYd8hqed5EOccgJbaNdA/DCM7QMU6nQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=izpA4tLm7A1NS0m8B28I1CiOp/9iap//sX3bsXcrqf+hr0YbITuFepME4ZP3znkXYbi9bfbYk67MqPmGeAGlTHEYXsBM+a0Br9Rw4X0/O/V6eNqfu7f4DGd8WA45zD4OaGh5N+wrv4xXkxbkyopiRcvsDDQN49t57wMmfnU1L0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=fVACUB16; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="fVACUB16"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 45D6C240029
	for <linux-unionfs@vger.kernel.org>; Fri, 12 Sep 2025 17:32:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1757691150; bh=IA5YNAoVNsEwinWOmnpmB4qrPZxT2JToTJ4rBj7Ifb8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=fVACUB1637j70F0nGEjP26fGFuqcHyj9SgDGbpOrbW3FlCDkLmSNFZRxRpXSMqZlj
	 upPQMz8ALJQ8d+8h7EavcStwNk4kR8QUwyS6HkUicD/gKVswdj35KMugjk9lfQiZj5
	 G7w1OSbgTfAbbMx4ikuPJBbXMudXo7bTtExjgJWSyQmQ9O4rDr63TA8I4EireDdsPg
	 ie+h9m8nRVb/Vka9TRjdECeahLh8/89klKe3QhUW9YfTm4xb+lVIhNjFcMrfOiE4Hf
	 UeH08jxunTPGfWiL1opqLUK+CB4qm66szqLzu+hurBdD8F2cKRWHa4qcad81c2wsIr
	 OfFi/5DsrnGpw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cNdhs2N0Mz6tx2
	for <linux-unionfs@vger.kernel.org>; Fri, 12 Sep 2025 17:32:29 +0200 (CEST)
From: Nicholas Hubbard <nicholashubbard@posteo.net>
To: linux-unionfs@vger.kernel.org
Subject: Support for including nested mountpoints in overlay?
Date: Fri, 12 Sep 2025 15:32:29 +0000
Message-ID: <87plbvadpw.fsf@slackpad.slackpad.domain>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello everybody,

I have just started working with overlayfs, and ran into a problem. Specifi=
cally
I wanted to overlay the root of my filesystem with a command like the follo=
wing:

# mount -t overlay overlay -o lowerdir=3D/,upperdir=3D./tmp-upper,workdir=
=3D./tmp-work ./merged

However, I noticed that my nested btrfs subvolumes and boot partition were =
not
included in ./merged. I quickly learned though that you could have multiple
lowerdirs. So next I tried the following command (I have a nested btrfs sub=
volume
at /home, and my boot partition mounted at /boot):

# mount -t overlay overlay -o lowerdir=3D/:/home:/boot,upperdir=3D./tmp-upp=
er,workdir=3D./tmp-work ./merged

I was expecting that now I would have (for example) the following directori=
es:

./merged/home/$USER
./merged/boot/grub

However I instead had:

./merged/$USER
./merged/grub

Which shows that all the lowerdirs are placed right at the root of the merg=
edir.

So I have two questions.

1. Is there a (easy) way say "I want to include all nested mountpoints into=
 the
   overlay in their same directories"?
2. If there is not a (easy) way to do this, do you think it would be both f=
easible
   and useful to add such a feature?

If the answer to question 2 is "yes", then I would be happy to take a try a=
t this :)

=2D-=20
Nicholas B. Hubbard
Keys: https://github.com/NicholasBHubbard/public-keys
Key ID: 508022AE06C2C446D8072447C700A066BB25F148

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQRQgCKuBsLERtgHJEfHAKBmuyXxSAUCaMQ9CwAKCRDHAKBmuyXx
SDVdAP4tK/Zrnh7EHJWTlgbiN1X6Gs94zb56sC2ypt7vrmCmGQD/SF50rj/a6OYA
jNeeAsYzDWtWLzm1zh09Zm8GgR0t3wg=
=Xhuq
-----END PGP SIGNATURE-----
--=-=-=--
