From: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Subject: Re: [RFC PATCH] overlayfs: support more than one read-only layer
Date: Mon, 10 Nov 2014 12:08:13 -0500
Message-ID: <376686B7-FF3A-4487-A457-EEA5C110B6F8@fsl.cs.sunysb.edu>
References: <20141107170242.GA333@tucsk> <20141108192723.444cecd2@gmail.com> <20141110090954.GB333@tucsk>
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141110090954.GB333@tucsk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jordi Pujol Palomer <jordipujolp@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "A. Wan" <jm@mokwan.com>, Patrick Frisch <patrick@frischux.de>, Aaron Campbell <aaron@arbor.net>
List-Id: linux-unionfs@vger.kernel.org

Indeed, Miklos, changing layers dynamically is VERY tricky.  Unionfs su=
pports that, but a good amount of its code all over is dedicated to han=
dling dynamic layer changes.  I advise you to avoid supporting this fea=
ture for a while, if ever: get a small, functional, working overlayfs f=
irst.

I personally never liked the idea of changing layers dynamically: it=E2=
=80=99s like asking a file system to remain consistent and detect all l=
ower changes when someone goes and hand-edits disk blocks.  Too messy. =
 The pain of developing and supporting such a feature is much greater t=
han the annoyance to users who have to unmount and remount back their l=
ayers to form a new structure.

Cheers,
Erez.

> On Nov 10, 2014, at 4:09 AM, Miklos Szeredi <miklos@szeredi.hu> wrote=
:
>=20
> As for changing the stacking while the overlayfs is mounted: currentl=
y this is
> not supported, the layers specified at the mount time remain there un=
til the
> overlay is unmounted.  Currently there's no possibility to add or rem=
ove layers
> in a dynamic way, and it is definitely more tricky to implement than =
the static
> configuration.
>=20
> Thanks,
> Miklos
