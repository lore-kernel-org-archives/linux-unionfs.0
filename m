From: Euan Kemp <euank@euank.com>
Subject: Re: [PATCH] ovl: fix regression caused by exclusive upper/work dir
 protection
Date: Fri, 6 Oct 2017 10:16:39 -0700
Message-ID: <20171006171639.5c2xq6utumnupfkb@Enkidudu>
References: <1506673327-5906-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxj6k3wgke8YHwLoQXZNHkuD1YkAMW73VmEuizoNP-TGVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="veiq3may3l4llknw"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:56882 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbdJFRQm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 13:16:42 -0400
Received: by mail-pg0-f45.google.com with SMTP id m18so4149960pgd.13
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Oct 2017 10:16:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj6k3wgke8YHwLoQXZNHkuD1YkAMW73VmEuizoNP-TGVA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, "# v4 . 13" <stable@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>


--veiq3may3l4llknw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 29, 2017 at 11:31:05AM +0300, Amir Goldstein wrote:
> Care to test this patch?

I can verify this patch resolves the issue I reported against the moby
project (https://github.com/moby/moby/issues/34672).

I think including this in the stable kernel makes sense; without this
there's noticeable userspace impact.

- Euan

--veiq3may3l4llknw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEE2vLQVz9g0pDwn0STaZWsAiv0ng0FAlnXunEACgkQaZWsAiv0
ng26NAgAh3R5TVH+P3bd9Ffu5gRh1TD6hAGad4VKaO5+41fyjMNlFiP0bTZGhRM3
F2e1+WohHv117NEMInLviHMzIbV65TXy7+LdnQfvdP1msnRdTw5ZpOEfjinfCe4+
lhZxtf75bMQEyntQ+GWU4kInm/EzkEebQnppoiM9UqXntzu4CPBRbIIzSYXcfYHz
mgjMa4s8t3PzVAWYKFWCPdfgoemAdCaJ4cPEZd1gIGJgCdUE+OdJsZ7ZZzdUIEba
N0KM4AKQJjYyoX7Qdsb4q055lHnUIR4STIDYQOEHTyunNJsda345gSvz/K440/yY
zaacRrKsx7JYlfNijt8l5c0ayuXY+Q==
=4PPY
-----END PGP SIGNATURE-----

--veiq3may3l4llknw--
