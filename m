Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0A7C2BA19
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 15:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6D1520767
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 15:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GQ0xWoRI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636915AbgDOPaq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 11:30:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54010 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636930AbgDOPam (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Apr 2020 11:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586964638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zifJJdBtdE3JvOhjfzXkcUYmdFG+r+rQcQ25XcDHw08=;
        b=GQ0xWoRIalSouZxJZJ4ncY9rj3busNjwDIpr/d78E+9xhWCwkunyCQ51a6FsZbY8We49Lg
        wSS7mFjFgjsoctO0Ho9QI6hJV5w8KhCwUbe/UKL+sM6ydzFpcUQekgIJG5INRHo9kqUwyY
        xjCE5Ap4TFhOFvMuBLtCU9FoKJaJ0B0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-dgTUx9bxM1O1RoTNZEOqAA-1; Wed, 15 Apr 2020 11:30:34 -0400
X-MC-Unique: dgTUx9bxM1O1RoTNZEOqAA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C54DB19057A3;
        Wed, 15 Apr 2020 15:30:33 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-127.rdu2.redhat.com [10.10.116.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCEF35D9E2;
        Wed, 15 Apr 2020 15:30:32 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 5C86F220935; Wed, 15 Apr 2020 11:30:32 -0400 (EDT)
Date:   Wed, 15 Apr 2020 11:30:32 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Configure custom layers via environment variables
Message-ID: <20200415153032.GC239514@redhat.com>
References: <20200415120134.28154-1-amir73il@gmail.com>
 <20200415120134.28154-3-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415120134.28154-3-amir73il@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 15, 2020 at 03:01:34PM +0300, Amir Goldstein wrote:
> The following environment variables are supported:
> 
>  UNIONMOUNT_BASEDIR  - base dir for --samefs (default: /base)
>  UNIONMOUNT_UPPERDIR - upper layer root path (default: /upper)
>  UNIONMOUNT_LOWERDIR - lower layer root path (default: /lower)
>  UNIONMOUNT_MNTPOINT - mount point for tests (default: /mnt)
> 
> User provided paths for base/lower/upper should point at a pre-mounted
> filesystem, whereas tmpfs instances will be created on default paths.
> 
> This is going to be used for running unionmount tests from xfstests.

Hi Amir,

I don't understand this testsuite code. So I will ask.

What's base dir?

So these options will allow me to specify lower directory, upper directory
and overlay mount point. User can specify these and testsuite will
mount overlay accordingly?

What about overlay mount options. Should there be one option for that too.

Assuming workdir is automatically determined.

Vivek

> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  README      | 11 +++++++++++
>  run         |  3 ++-
>  settings.py | 51 ++++++++++++++++++++++++++++++---------------------
>  3 files changed, 43 insertions(+), 22 deletions(-)
> 
> diff --git a/README b/README
> index c352878..616135f 100644
> --- a/README
> +++ b/README
> @@ -47,5 +47,16 @@ To run these tests:
>  	./run --ov --fuse=<subfs-type>
>  
>  
> +The following environment variables are supported:
> +
> +     UNIONMOUNT_BASEDIR  - base dir for --samefs (default: /base)
> +     UNIONMOUNT_UPPERDIR - upper layer root path (default: /upper)
> +     UNIONMOUNT_LOWERDIR - lower layer root path (default: /lower)
> +     UNIONMOUNT_MNTPOINT - mount point for tests (default: /mnt)
> +
> +     User provided paths for base/lower/upper should point at a pre-mounted
> +     filesystem, whereas tmpfs instances will be created on default paths.
> +
> +
>  For more advanced overlayfs test options and more examples, see:
>       https://github.com/amir73il/overlayfs/wiki/Overlayfs-testing
> diff --git a/run b/run
> index e6262b8..60d5d0d 100755
> --- a/run
> +++ b/run
> @@ -20,10 +20,11 @@ def show_format(why):
>      print("\t", sys.argv[0], "--<fsop> <file> [<args>*] [-aLlv] [-R <content>] [-B] [-E <err>]")
>      sys.exit(2)
>  
> +cfg = config(sys.argv[0])
> +
>  if len(sys.argv) < 2:
>      show_format("Insufficient arguments")
>  
> -cfg = config(sys.argv[0])
>  args = sys.argv[1:]
>  
>  ###############################################################################
> diff --git a/settings.py b/settings.py
> index ced9cae..f065494 100644
> --- a/settings.py
> +++ b/settings.py
> @@ -20,15 +20,27 @@ along with this program; if not, write to the Free Software
>  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>  """
>  
> +import os
> +
>  class config:
>      def __init__(self, progname):
>          self.__progname = progname
>          self.__testing_overlayfs = False
>          self.__testing_none = False
> -        self.__base_mntroot = None
> -        self.__lower_mntroot = None
> -        self.__upper_mntroot = None
> -        self.__union_mntroot = None
> +        self.__base_mntroot = os.getenv('UNIONMOUNT_BASEDIR')
> +        self.__lower_mntroot = os.getenv('UNIONMOUNT_LOWERDIR')
> +        self.__upper_mntroot = os.getenv('UNIONMOUNT_UPPERDIR')
> +        self.__union_mntroot = os.getenv('UNIONMOUNT_MNTPOINT')
> +        print("Environment variables:")
> +        if self.__base_mntroot:
> +            print("UNIONMOUNT_BASEDIR=" + self.__base_mntroot)
> +        if self.__lower_mntroot:
> +            print("UNIONMOUNT_LOWERDIR=" + self.__lower_mntroot)
> +        if self.__upper_mntroot:
> +            print("UNIONMOUNT_UPPERDIR=" + self.__upper_mntroot)
> +        if self.__union_mntroot:
> +            print("UNIONMOUNT_MNTPOINT=" + self.__union_mntroot)
> +        print()
>          self.__verbose = False
>          self.__verify = False
>          self.__maxfs = 0
> @@ -50,49 +62,46 @@ class config:
>          return self.__testing_overlayfs
>  
>      def set_testing_none(self):
> -        self.__lower_mntroot = "/lower"
> -        self.__union_mntroot = "/mnt"
>          self.__testing_none = True
>  
>      def set_testing_overlayfs(self):
> -        self.__base_mntroot = "/base"
> -        self.__lower_mntroot = "/lower"
> -        self.__upper_mntroot = "/upper"
> -        self.__union_mntroot = "/mnt"
>          self.__testing_overlayfs = True
>  
>      # base dir is mounted only for --ov --samefs
> +    # A user provided base dir should already be mounted
>      def should_mount_base(self):
> -        return self.testing_overlayfs() and self.is_samefs()
> +        return self.__base_mntroot is None and self.testing_overlayfs() and self.is_samefs()
>      def base_mntroot(self):
> -        return self.__base_mntroot
> +        return self.__base_mntroot or "/base"
>      # lower dir is mounted ro for --ov (without --samefs) ...
>      def should_mount_lower_ro(self):
> -        return self.testing_overlayfs() and not self.is_samefs()
> +        return self.__lower_mntroot is None and self.testing_overlayfs() and not self.is_samefs()
>      # ... and mounted rw for --no
> +    # A user provided lower dir should already be mounted
>      def should_mount_lower_rw(self):
> -        return self.testing_none()
> +        return self.__lower_mntroot is None and self.testing_none()
>      def should_mount_lower(self):
>          return self.should_mount_lower_ro() or self.should_mount_lower_rw()
>      def set_lower_mntroot(self, path):
>          self.__lower_mntroot = path
>      def lower_mntroot(self):
> -        return self.__lower_mntroot
> +        return self.__lower_mntroot or "/lower"
>      # upper dir is mounted for --ov (without --samefs)
> +    # A user provided upper dir should already be mounted
>      def should_mount_upper(self):
> -        return self.testing_overlayfs() and not self.is_samefs()
> +        return self.__upper_mntroot is None and self.testing_overlayfs() and not self.is_samefs()
>      def set_upper_mntroot(self, path):
>          self.__upper_mntroot = path
>      def upper_mntroot(self):
> -        return self.__upper_mntroot
> +        return self.__upper_mntroot or "/upper"
>      def union_mntroot(self):
> -        return self.__union_mntroot
> +        return self.__union_mntroot or "/mnt"
>      def lowerdir(self):
> -        return self.__lower_mntroot + "/a"
> +        return self.lower_mntroot() + "/a"
>      def lowerimg(self):
> -        return self.__lower_mntroot + "/a.img"
> +        return self.lower_mntroot() + "/a.img"
>      def testdir(self):
> -        return self.__union_mntroot + "/a"
> +        return self.union_mntroot() + "/a"
>  
>      def set_verbose(self, to=True):
>          self.__verbose = to
> -- 
> 2.17.1
> 

