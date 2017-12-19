From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3] ovl: Check link ability between upperdir and workdir
Date: Tue, 19 Dec 2017 10:42:42 -0500
Message-ID: <20171219154242.GA6043@redhat.com>
References: <1513601748-57439-1-git-send-email-cgxu519@icloud.com>
 <20171218160251.GA7474@redhat.com>
 <C6350633-4F41-424F-B936-606CDAF2A8DF@icloud.com>
 <20171219134849.GA2737@redhat.com>
 <CAOQ4uxi-wpRdUv20uaSrE=R_kYWcb8jmOUu-Xp+XeA-AA0-eWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35294 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751517AbdLSPmn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Dec 2017 10:42:43 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi-wpRdUv20uaSrE=R_kYWcb8jmOUu-Xp+XeA-AA0-eWA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chengguang Xu <cgxu519@icloud.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Dec 19, 2017 at 04:11:13PM +0200, Amir Goldstein wrote:
[..]
> With non-indexed copy up (of regular file, when O_TMPFILE supported)
> tmpfile is created in upperdir and linked to upper dir, which allows for
> concurrent copy up of two files within different parent dirs.

Is it correct. I am looking at the code and we always seem to get tmpfile
in work/work.

ovl_copy_up_locked()
  ovl_get_tmpfile()
      ovl_do_tmpfile(c->workdir, c->stat.mode)

I was hoping that for a regular file copy up, we could create tmpfile in
upper/ so that we don't have the requirement of allowing linking between
work/ and upper/ as long as upper supported tmpfile. But given that index 
will require linking with alias in upper, we can't get rid of this
requirement completely.

Vivek
