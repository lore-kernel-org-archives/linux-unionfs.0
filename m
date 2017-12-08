From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH v2] ovl: don't follow redirects if redirect_dir=off
Date: Fri, 08 Dec 2017 14:36:48 +0000
Message-ID: <30533.1512743808@warthog.procyon.org.uk>
References: <20171206150333.GB24303@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753691AbdLHOgv (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Dec 2017 09:36:51 -0500
In-Reply-To: <20171206150333.GB24303@veci.piliscsaba.redhat.com>
Content-ID: <30532.1512743808.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>

Miklos Szeredi <miklos@szeredi.hu> wrote:

> +	const char *redirect_mode;
> ...
> +	kfree(ofs->config.redirect_mode);

That's going to get you a compiler warning under some circumstances.

> +			config->redirect_mode = match_strdup(&args[0]);

We shouldn't really be copying the string if we can help it, though I grant we
may not have the match_*() function to do otherwise at the moment.  I would
much prefer seeing it rendered to an enum value at this point.

David
