From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/4] src/open_by_handle: flexible usage options
Date: Wed, 19 Apr 2017 18:02:08 +0800
Message-ID: <20170419100208.GS8951@eguan.usersys.redhat.com>
References: <1492539444-25938-1-git-send-email-amir73il@gmail.com>
 <1492539444-25938-3-git-send-email-amir73il@gmail.com>
 <20170419094202.GO8951@eguan.usersys.redhat.com>
 <CAOQ4uxjo+tMAnCWYfby-n+dJSyYCe1q1MHDvTkF=DDMQeS071w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761980AbdDSKCL (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 06:02:11 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjo+tMAnCWYfby-n+dJSyYCe1q1MHDvTkF=DDMQeS071w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Wed, Apr 19, 2017 at 12:57:49PM +0300, Amir Goldstein wrote:
...
> >> @@ -95,14 +139,32 @@ int main(int argc, char **argv)
> >>               }
> >>       }
> >>
> >> +     /* after creating test set only check that fs supports exportfs */
> >> +     if (create)
> >> +             return EXIT_SUCCESS;
> >
> > "-c" means "Create N test files (nlink=1) under test_dir and exit", so
> > we could move it before name_to_handle_at() calls?
> 
> That's the wording from commit message which is out of date.
> usage says -c also tries to get handles, because it is being used for
> _require_exportfs

Right, I missed that. Then yes, commit message should be updated :)

Thanks,
Eryu
