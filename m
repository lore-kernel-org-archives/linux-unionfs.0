From: David Howells <dhowells@redhat.com>
Subject: Re: Optional switching off cow in overlayfs
Date: Tue, 23 Jun 2015 14:23:48 +0100
Message-ID: <32715.1435065828@warthog.procyon.org.uk>
References: <55893699.6090109@samsung.com> <55882AA5.10908@samsung.com> <5582C6C1.8080602@samsung.com> <13405.1434634748@warthog.procyon.org.uk> <5582D8F7.1060700@samsung.com> <CAJfpegsP-_MAKybYZ=uS3UCxsxL9Hv-cJ-GYrVL4h3B+tWZF9A@mail.gmail.com> <5588116E.20509@samsung.com> <CAJfpegsVqzVhq8BjCwqA+6dEZey0aNb4amnnOT_JVDfzki9v1g@mail.gmail.com> <55881B2A.7090106@samsung.com> <CAJfpegtcUt6jR7t_2Ca1osu6+-BKGtnTVVTVXEcWrqBtY0fCzA@mail.gmail.com> <29219.1435051659@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbbFWNXw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 23 Jun 2015 09:23:52 -0400
In-Reply-To: <55893699.6090109@samsung.com>
Content-ID: <32714.1435065828.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Olszak <j.olszak@samsung.com>
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Jan Olszak <j.olszak@samsung.com> wrote:

> Why not just say: "rename causes copy" and leave everything as it is now.

That's another option - but your whole proposal was that we specifically don't
copy up these files IIRC.

David
