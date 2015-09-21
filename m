From: Matthew Cengia <mattcen@cyber.com.au>
Subject: Fwd: overlayfs+selinux error: OPNOTSUPP
Date: Mon, 21 Sep 2015 17:43:35 +1000
Message-ID: <20150921074335.GI22582@cyber.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Tnj+unmjHTqEM5y0"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from stomp.cyber.com.au ([203.7.155.6]:56354 "EHLO
	stomp.cyber.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbbIUHux (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 21 Sep 2015 03:50:53 -0400
Received: from cyber.com.au (flora.cyber.com.au [203.7.155.138])
	by stomp.cyber.com.au (Postfix) with ESMTPSA id 773E0F1F
	for <linux-unionfs@vger.kernel.org>; Mon, 21 Sep 2015 17:43:33 +1000 (AEST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org


--Tnj+unmjHTqEM5y0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I've posted a message to LKML on Friday, and subsequently, upon
recommendation, have posted to the SELinux list, but then I stumbled
upon this list, which seems to have at least semi-relevent discussion on
SELinux/overlay interactions. I'd really appreciate if you folks could
have a look at my post (https://lkml.org/lkml/2015/9/17/888) to see if
it's anything you're able to help with; I'm running out of ideas!

----- Forwarded message from Matthew Cengia <mattcen@cyber.com.au> -----

> Date: Fri, 18 Sep 2015 12:07:43 +1000
> From: Matthew Cengia <mattcen@cyber.com.au>
> To: linux-kernel@vger.kernel.org
> Cc: Matthew Cengia <mattcen@gmail.com>, "Trent W. Buck" <twb@cyber.com.au>
> Subject: overlayfs+selinux error: OPNOTSUPP
> Message-ID: <20150918020743.GC22582@cyber.com.au>
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> Hi all,
>=20
> Please CC me directly when responding, as I'm not subscribed to the
> mailing list.
>=20
>=20
> Summary
> -------
> I deploy diskless Debian kiosks in prisons, for use by inmates.
> As part of the Debian 7 to 8 upgrade, I want to enable SELinux.
> My initrd uses overlayfs to combine a ro squashfs and a rw tmpfs.
>=20
> When I add SELinux into the mix, I get a lot of EOPNOTSUPP.
[...]
----- End forwarded message -----

--=20
Regards,
Matthew Cengia

--Tnj+unmjHTqEM5y0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQJ8BAEBCgBmBQJV/7UmXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRDMTlFRDFDRTdERThBODYxMjhGOEQwNEI5
RDBCNTY1NTlCRjZBNTYyAAoJEJ0LVlWb9qViI7IQAI8rxmshasItZC68ZG2a4MDY
DPhQxqlYck92BysMZ48UQhQOIyopTNjDm23Fl+6ldOG6b0CyhupolIG6TXp3u/2C
yr02ufqp0dPNmxpKLQk6Ko97XmBGF4El5YKdJbzdCyU3ZrSxQWpdqng2mwn7yA1+
AIjFX3aoag/qnZu6l7dUXH3fTqP+qvVIA5DiMLFoVELhe2uM1dzJd/1adzW3f0cU
bYCVoX3Z1PhmFZlwOKQIT+f5Bjb+BzSfZEcHIbwue8osg833JVOruKyMfXUE2g79
bdNvOrPt8I/J70qawYzlSO2xgb+28Pr3+DeNiaC4J7jCh6BXJIVAYxW6MBVXfvn3
oqK3rLwRo2rrJQGQ3h2DTMz929xLVDh5MRzLHBB3yLfhXXi8G0Q7O22oS2KbvdNr
PvnKyowjzBJflJGUhdoGxGOeaM3EVvD3c1y11iljfNfe1Wh2Nn56D6qqhhQ2itk6
1J+Pk7D5BmruXuX3ge7LLJjz+F0r8RFXcKQO758umb6iZVacaUF+ZJAdaFW8mHbO
7X1z3ra8HwW3FceC5mJjczoJetHluY5s5JeIHmKkH7ZM4WkeiK3k7Oa+yJfHPByu
+VQ/V8n8MJXY/powH0+QQd/bi+NrEWXuRTL0Axz81FYY11Xvs24EGyZyCjJExgA0
mMQRvCLjRMyb6pwJu2b/
=gMe9
-----END PGP SIGNATURE-----

--Tnj+unmjHTqEM5y0--
