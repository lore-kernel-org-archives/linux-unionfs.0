Return-Path: <cgxu519@mykernel.net>
Date: Sun, 03 Nov 2019 20:43:37 +0800
From: Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
Message-ID: <16e314ad3bc.f4c363d96385.3761437052169638038@mykernel.net>
In-Reply-To: <CAOQ4uxhdSXAvFQfhzZpBC=Xmmo9y+3AOU1o-tOWsLtr2ntU6Ag@mail.gmail.com>
References: <20191030124431.11242-1-cgxu519@mykernel.net> <CAOQ4uxh670WFhwpQyPFTB2nUCSc9n1VmuyPOfdqiBSsq6GxLpQ@mail.gmail.com>
 <16e204de70e.cefd69461771.2205150443916624303@mykernel.net> <CAOQ4uxhdSXAvFQfhzZpBC=Xmmo9y+3AOU1o-tOWsLtr2ntU6Ag@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: improving copy-up efficiency for big sparse
 file
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2019-10-31 14:53:15 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > Yes, overlayfs does not comply with this "posix"' test.
 > >  > This is why it was removed from the auto and quick groups.
 > >
 > > So I'm curious what is the purpose for the test?
 > >
 >=20
 > This is a POSIX compliance test.
 > It is meant to "remind" us that this behavior is not POSIX compliant
 > and that we should fix it one day...
 > A bit controversial to have a test like this without a roadmap
 > when it is going to be fixed in xfstests, but it's there.

I haven't checked carefully for the detail but It seems  feasible if we cop=
y-up lower file  during mmap regardless of ro/rw mode.
Is it acceptable  by slightly changing copy-up assumption to fulfill POSIX =
compliance? Or we just wait for a better solution?

Thanks,
Chengguang
