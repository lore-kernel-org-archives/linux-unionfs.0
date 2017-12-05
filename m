From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH] ovl: don't follow redirects if redirect_dir=off
Date: Tue, 05 Dec 2017 14:36:13 +0000
Message-ID: <7051.1512484573@warthog.procyon.org.uk>
References: <20171205133707.GA24303@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28596 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752632AbdLEOgQ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Dec 2017 09:36:16 -0500
In-Reply-To: <20171205133707.GA24303@veci.piliscsaba.redhat.com>
Content-ID: <7050.1512484573.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>

Miklos Szeredi <miklos@szeredi.hu> wrote:

> +static const bool ovl_redirect_follow_def =
> +	IS_ENABLED(CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW);

This would be better as a #def'd constant rather than a constant variable so
that it can be used to optimise stuff away and so that it won't take up
.rodata space.

David
