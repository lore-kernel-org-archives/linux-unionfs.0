From: David Howells <dhowells@redhat.com>
Subject: Re: Overlay filesystem doesn't feed "tail -f"
Date: Wed, 10 Jun 2015 14:10:43 +0100
Message-ID: <29748.1433941843@warthog.procyon.org.uk>
References: <CA+X5Wn43D7+LKyYrz5UCm7rXvvzL84g2WNKTKHJP35EEXRyRHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964944AbbFJNKr (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 10 Jun 2015 09:10:47 -0400
In-Reply-To: <CA+X5Wn43D7+LKyYrz5UCm7rXvvzL84g2WNKTKHJP35EEXRyRHw@mail.gmail.com>
Content-ID: <29747.1433941843.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: james harvey <jamespharvey20@gmail.com>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org

james harvey <jamespharvey20@gmail.com> wrote:

> If a file in an overlay merged directory is being periodically written
> to: tail -f will not show additions if given the file in the location
> of the merged directory; but tail -f will show additions if given the
> file in the location of the lower directory.

Yeah.  It uses inotify.  Inotify and file locking are hard things and aren't
yet supported.

David
