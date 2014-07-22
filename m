From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: aufs as root vor openvz CT
Date: Tue, 22 Jul 2014 09:32:49 +0200
Message-ID: <1728348.LhyPPIypjG@xrated>
References: <CAKG6wnaq1BwLgMNy27i8ggzt_qMnUb0KVNQg=Z85nz1LbXttUg@mail.gmail.com> <29716.1405886425@jrobl> <CAKG6wnYsDk8_JoG8QrHZ3ZtDicnwt__6AGTod-Ozqi5gjoZTdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:61790 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaGVHdC (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 22 Jul 2014 03:33:02 -0400
In-Reply-To: <CAKG6wnYsDk8_JoG8QrHZ3ZtDicnwt__6AGTod-Ozqi5gjoZTdw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: aufs-users@lists.sourceforge.net
Cc: Sergey Korshunoff <seyko2@gmail.com>, sfjro@users.sourceforge.net, linux-unionfs@vger.kernel.org

Dear Junjiro, dear Sergey,

first of all, I just try to transform the communication between you two in 
order to help both parties. I'm not affiliated in any of the two, its just a 
poor mans AUFS contribution.

On Montag, 21. Juli 2014 15:33:15 Sergey Korshunoff wrote:
> > I won't be helpful for you until you give me enough information.
> > Do you have any special reason not to give the information?
> 
> I'm trying to use a aufs as a root fs for container. I use openvz
> kernels 2.6.18 and 2.6.32. While container starts, stops and works
> well it can not be suspended. There is nothing special to a kernel
> version and even union fs type (aufs, uniionfs). Problem is common to
> any stacked fs which opens fd itself. This is why I do not try to
> give info asked in README
> 
> Suspend count currently a fd opened by a stacked fs (internal fd) as a
> fd opened by application in container. I'm trying to ask openvz
> developers (https://bugzilla.openvz.org/show_bug.cgi?id=3024) about a
> method allowing to exclude internal fd of stacked fs from a suspend
> set.
> 
> Suspend perform a closing of the opened fd's. This fd's are reopened
> while resume is performed. Internal fd's of the stacked fs must not be
> counted by this processes.

Junjiro, openvz is a container technology (CT) similar to docker. I can 
imagine, that these technologies have a problem, that describes as follows:

In order to perform a proper suspend/resume cycle, the CT has to arrange 
everything to the state before the suspend. Therefore, they track the opened 
files, and restore their state during resume. Layering FS (LFS) do cause 
problems in this scenario, since files opened by them don't belong to any 
application running in the container.

As it stands, a LFS can't do much to solve the problem in itself, other then 
hinting the CT during suspend, which fd is used by the LFS itself. The CT 
should simply ignore those on resume, given, that opening the fd and restoring 
its state in the application layer should restore the LFS arrangement 
implicitly.

Since this issue is generic to LFS using their own fds, I'm sending this to 
the new linux-unionfs ML, too, and suggest to discuss it any further over 
there.

So, either define a special open flag for LFS internal fds, which, I guess, is 
rather unpopular, or define a respective fcntl, that those LFS should 
implement. Otherwise, every CT needs to detect the internal fds of every LFS 
implementation heuristically, which is the worst solution, of course.

Pete
