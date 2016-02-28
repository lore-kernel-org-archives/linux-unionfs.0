From: Ignacy =?iso-8859-2?Q?Gaw=EAdzki?=
	<ignacy.gawedzki@green-communications.fr>
Subject: Re: [PATCH v2 1/1] OverlayFS: Fix checking permissions during lookup.
Date: Sun, 28 Feb 2016 12:09:42 +0100
Message-ID: <20160228110942.GA19509@zenon.in.qult.net>
References: <20160224135552.GB8422@zenon.in.qult.net>
 <20160226194143.GB13054@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from str75-3-78-193-33-39.fbxo.proxad.net ([78.193.33.39]:39072 "EHLO
	mail.qult.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041AbcB1LJx (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 28 Feb 2016 06:09:53 -0500
Content-Disposition: inline
In-Reply-To: <20160226194143.GB13054@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Feb 26, 2016 at 02:41:43PM -0500, thus spake Vivek Goyal:
> CCing linux-fsdevel as it is a wider issue.
>=20
>=20
> On Wed, Feb 24, 2016 at 02:55:52PM +0100, Ignacy Gaw=EAdzki wrote:
> > Add alternate lookup_one_len_check function to fs/namei.c which doe=
s
> > what lookup_one_len did until now with a boolean argument telling
> > whether to check that the base directory is traversable.  Modify
> > original lookup_one_len function to call the former with true as th=
e
> > last argument.
> >=20
> > In function ovl_lookup_real, file fs/overlayfs/super.c, call
> > lookup_one_len_check with false as the last argument, so that failu=
re
> > to traverse the base directory does not return -EACCES.  This shoul=
d
> > make lookup resolution work properly in the following setup
> >=20
> >   drwxr-xr-x lower/
> >   drwx------ lower/foo/
> >   drw-r--r-- lower/boo/bar
> >   drwxr-xr-x upper/
> >   drwxr-xr-x upper/foo/
> >=20
> > when any user not being the owner of lower/foo is trying to access
> > foo/bar in the mounted overlay.
>=20
> So what's the problem we are trying to solve. Why should we able to
> override the DAC checks of lower layer if same directory in upper
> is searchable for user but it is not searchable in lower layer.=20

My point is that an overlay filesystem should have consistent
semantics.  The current state of affairs fails in this regard on two
points.  First, suppose you have the same lower as above, but upper is
empty.  Then initially, foo/ has permissions 700 and shouldn't be
traversable by anyone but user root and the owner of foo/.  But if user
root or the owner changes foo's permissions to 755, a foo directory is
created in the upper layer and we arrive at the exact same
configuration as above.  In this case, I don't think anyone would
expect other users be denied traversal of foo to access bar.  Second,
the state of the cache shouldn't have any influence on the way access
rights are enforced.  In the present case, traversal of foo is granted
to other users depending on whether the owner or root already accessed
bar.

Besides, according to Documentation/fs/overlay.txt:

  Only the lists of names from directories are merged.  Other content
  such as metadata and extended attributes are reported for the upper
  directory only.  These attributes of the lower directory are hidden.

which implies that lower's permissions of foo should be ignored if foo
exists in upper as well.

Cheers,

Ignacy

--=20
Ignacy Gaw=EAdzki
R&D Engineer
Green Communications
