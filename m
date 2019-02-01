Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbfBAQ31 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 1 Feb 2019 11:29:27 -0500
Date: Fri, 1 Feb 2019 11:29:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
Message-ID: <20190201162926.GA26780@redhat.com>
References: <CAJfpegsjfxTV44SbcKzV7T2U+BbOqgwLHgr7-jctqgUXxYzM_A@mail.gmail.com>
 <CAOQ4uxhnFeL-pHY6AM8UWD9RDu-RN=xuM-RCoq5Mw_htUvHBFA@mail.gmail.com>
 <CAJfpegv_GkeGapuTGDMtF79GL1iZK5+HA_p1+OQpqXhZsrS4JQ@mail.gmail.com>
 <CAOQ4uxgcCdpYoAbo5mp5AvdW9B-ENAJXgQbOtjsQoHKjr_b8iA@mail.gmail.com>
 <CAJfpegu_w+xfONCDMoqtLs=r6J8DUBjTU_W=pchRK0URum8c+Q@mail.gmail.com>
 <CAOQ4uxj08PhC2+h1LL+iKrAGnKXvT-oYNkFOjUqHrnBf84DswA@mail.gmail.com>
 <CAJfpegv1J4TvmhUvogGUP5pOZNT+gnRr1ygjWnyt7M56dirP0A@mail.gmail.com>
 <CAOQ4uxjh4yieJaacbP+5JbRY+=LV4oJU+1JCGV4S+eLE7FEcAw@mail.gmail.com>
 <CAJfpegu98HhOpajUOEm3OXXXTR4kePK-X3_hZurfDd=u0eHC0g@mail.gmail.com>
 <CAOQ4uxiZu5-Lvy7eeRKmHMwKh7D+zETTQ_4X3=_or4yVarU-4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiZu5-Lvy7eeRKmHMwKh7D+zETTQ_4X3=_or4yVarU-4A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Feb 01, 2019 at 03:22:34PM +0200, Amir Goldstein wrote:

[..]
> New lazy copy up semantics:
> overlay/060

Right now we open file with O_APPEND to make sure data is copied up. We
could probably change that to write some data to file and then make sure
file is copied up? Anyway, we are not promising that file will definitely
get copied up after opening with O_RDWR or O_APPEND.

And could add some tests for lazy copy up to make sure opening file
with O_RDWR alone does not do data copy up. (If lazy copy up is
enabled).

Vivek
