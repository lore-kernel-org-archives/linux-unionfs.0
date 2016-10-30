From: Amir Goldstein <amir73il@gmail.com>
Subject: Fwd: ACL test failures on overlayfs over tmpfs
Date: Sun, 30 Oct 2016 15:36:56 +0200
Message-ID: <CAOQ4uxg-LSz38U6+EkXMPx4TZgbRPDw_8K34C3oxW8MyEVZwJA@mail.gmail.com>
References: <CAOQ4uxgFBZumexGm0qtN70qwmYraxMMEzHgSLHHzT1ZYUnn-hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37821 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753454AbcJ3Ng6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 30 Oct 2016 09:36:58 -0400
Received: by mail-wm0-f52.google.com with SMTP id t79so7926343wmt.0
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Oct 2016 06:36:57 -0700 (PDT)
In-Reply-To: <CAOQ4uxgFBZumexGm0qtN70qwmYraxMMEzHgSLHHzT1ZYUnn-hw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

Hi guys,

I recently learned about a set of ACL tests that were added
by Tuxera to pjdtests. I pushed a branch to my github with
some fixes to build and run on recent Linux:

https://github.com/amir73il/pjdfstest.git #tuxera-acl-tests

While the set of ACL tests pass on overlayfs over xfs/ext4
some fail on overlayfs over tmpfs.
Below is a snippet from one of the failed tests.
The test setup grants read-only access to a 'foreign' user
and write-only access to a 'foreign' group (i.e. not the owner).

The return value from the 4 open statements at the bottom
of the test are correct when run on tmpfs/xfs/ext4 and they
are correct when run on overlayfs over xfs/ext4.

However, when running the same test on overlayfs over tmpfs
(both lower and upper) all 4 open statements fail with EACCESS
as if the ACL permission grant for the foreign user/group are skipped.

I tried following the permission checks code and got lost.

Can you shed some light on this for me?

Thanks,
Amir.

# create a basic directory, clean its inherited ACLs, and check initial ACL
# 1
expect 0 mkdir ${d0} 0777
expect 0 setfacl ${d0} b
expect 0 create ${d0}/${n1} 0644
expect 0 chown ${d0}/${n1} 65533 65533
expect 'u::rw-,g::r--,o::r--' getfacl ${d0}/${n1} access
expect EACCES getfacl ${d0}/${n1} default
#
# Grant read or write access to another user or group, check access
# 6
expect 0 setfacl ${d0}/${n1} m 'u::-,g::-,o::-,m::rw,u:65531:r,g:65532:w'
expect 0 -u 65531 -g 65531 open ${d0}/${n1} O_RDONLY
expect EACCES -u 65531 -g 65531 open ${d0}/${n1} O_RDWR
expect 0 -u 65532 -g 65532 open ${d0}/${n1} O_WRONLY
expect EACCES -u 65532 -g 65532 open ${d0}/${n1} O_RDWR
