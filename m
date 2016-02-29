From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 1/1] OverlayFS: Fix checking permissions during lookup.
Date: Mon, 29 Feb 2016 11:25:46 -0500
Message-ID: <20160229162546.GA3335@redhat.com>
References: <20160224135552.GB8422@zenon.in.qult.net>
 <20160226194143.GB13054@redhat.com>
 <20160228110942.GA19509@zenon.in.qult.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbcB2QZr (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 29 Feb 2016 11:25:47 -0500
Content-Disposition: inline
In-Reply-To: <20160228110942.GA19509@zenon.in.qult.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Ignacy =?utf-8?B?R2F3xJlkemtp?= <ignacy.gawedzki@green-communications.fr>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>

On Sun, Feb 28, 2016 at 12:09:42PM +0100, Ignacy Gaw=C4=99dzki wrote:
> On Fri, Feb 26, 2016 at 02:41:43PM -0500, thus spake Vivek Goyal:
> > CCing linux-fsdevel as it is a wider issue.
> >=20
> >=20
> > On Wed, Feb 24, 2016 at 02:55:52PM +0100, Ignacy Gaw=C4=99dzki wrot=
e:
> > > Add alternate lookup_one_len_check function to fs/namei.c which d=
oes
> > > what lookup_one_len did until now with a boolean argument telling
> > > whether to check that the base directory is traversable.  Modify
> > > original lookup_one_len function to call the former with true as =
the
> > > last argument.
> > >=20
> > > In function ovl_lookup_real, file fs/overlayfs/super.c, call
> > > lookup_one_len_check with false as the last argument, so that fai=
lure
> > > to traverse the base directory does not return -EACCES.  This sho=
uld
> > > make lookup resolution work properly in the following setup
> > >=20
> > >   drwxr-xr-x lower/
> > >   drwx------ lower/foo/
> > >   drw-r--r-- lower/boo/bar
> > >   drwxr-xr-x upper/
> > >   drwxr-xr-x upper/foo/
> > >=20
> > > when any user not being the owner of lower/foo is trying to acces=
s
> > > foo/bar in the mounted overlay.
> >=20
> > So what's the problem we are trying to solve. Why should we able to
> > override the DAC checks of lower layer if same directory in upper
> > is searchable for user but it is not searchable in lower layer.=20
>=20
> My point is that an overlay filesystem should have consistent
> semantics.  The current state of affairs fails in this regard on two
> points.  First, suppose you have the same lower as above, but upper i=
s
> empty.  Then initially, foo/ has permissions 700 and shouldn't be
> traversable by anyone but user root and the owner of foo/.  But if us=
er
> root or the owner changes foo's permissions to 755, a foo directory i=
s
> created in the upper layer and we arrive at the exact same
> configuration as above.  In this case, I don't think anyone would
> expect other users be denied traversal of foo to access bar.

I agree that semantics should be more consistent. I don't know that
if upper layer should override lower layer checks or not.

One could also argue that if root did chown, then changes effectively
happened in upper layer and anything in upper layer should become
visible to unpriviliged user but not the one in lower layer.=20

I just don't know. I guess those who have more background on this
could pitch in and clarify that was is supposed to be the design
intention.


> Second,
> the state of the cache shouldn't have any influence on the way access
> rights are enforced.  In the present case, traversal of foo is grante=
d
> to other users depending on whether the owner or root already accesse=
d
> bar.

If we decide not to override checks from lower layer, then this is
an isue at caching level and requires fixing at that level.

>=20
> Besides, according to Documentation/fs/overlay.txt:
>=20
>   Only the lists of names from directories are merged.  Other content
>   such as metadata and extended attributes are reported for the upper
>   directory only.  These attributes of the lower directory are hidden=
=2E
>=20
> which implies that lower's permissions of foo should be ignored if fo=
o
> exists in upper as well.

Right, but it does not say anything about what happens to DAC checks
at lower layer. IOW, it does not say that if lower directory owner
is different then whether files from that directory will become searcha=
ble
or not.

Thanks
Vivek
