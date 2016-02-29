From: Ignacy =?iso-8859-2?Q?Gaw=EAdzki?=
	<ignacy.gawedzki@green-communications.fr>
Subject: Re: [PATCH v2 1/1] OverlayFS: Fix checking permissions during lookup.
Date: Mon, 29 Feb 2016 17:54:40 +0100
Message-ID: <20160229165440.GA28299@zenon.in.qult.net>
References: <20160224135552.GB8422@zenon.in.qult.net>
 <20160226194143.GB13054@redhat.com>
 <20160228110942.GA19509@zenon.in.qult.net>
 <20160229162546.GA3335@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from str75-3-78-193-33-39.fbxo.proxad.net ([78.193.33.39]:48344 "EHLO
	mail.qult.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbcB2Qyx (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 29 Feb 2016 11:54:53 -0500
Content-Disposition: inline
In-Reply-To: <20160229162546.GA3335@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>

On Mon, Feb 29, 2016 at 11:25:46AM -0500, thus spake Vivek Goyal:
> I agree that semantics should be more consistent. I don't know that
> if upper layer should override lower layer checks or not.
>=20
> One could also argue that if root did chown, then changes effectively
> happened in upper layer and anything in upper layer should become
> visible to unpriviliged user but not the one in lower layer.=20
>=20
> I just don't know. I guess those who have more background on this
> could pitch in and clarify that was is supposed to be the design
> intention.
>=20
> [...]
>=20
> Right, but it does not say anything about what happens to DAC checks
> at lower layer. IOW, it does not say that if lower directory owner
> is different then whether files from that directory will become searc=
hable
> or not.

I suppose that looking at these questions from the perspective of the
primary application of OverlayFS, i.e. embedded systems with lower
being some read-only SquashFS and upper being read-write, may give
some good intuition on how this should work.  If the root user changes
access rights to some directories, then it is natural that permissions =
in
upper are less restrictive than permissions in lower and this in no
way breaks any security.  If you're thinking about what happens if
some overlay is mounted where the more permissive directory in upper
shadows a less permissive one in lower, then well, the only user able
to mount such an overlay, i.e. root, should know what she's doing.

Anyway, DAC checks should be consistent from the standpoint of
userland, first and foremost.

--=20
Ignacy Gaw=EAdzki
R&D Engineer
Green Communications
