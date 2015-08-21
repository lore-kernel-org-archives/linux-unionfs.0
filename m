From: Neal Gompa <ngompa@fedoraproject.org>
Subject: Issue: With an OverlayFS that has Btrfs as the upper layer, removal
 of directories silently fails
Date: Fri, 21 Aug 2015 15:23:07 -0400
Message-ID: <CAEg-Je9o6QTyjD7pnSiTeUgaZjN10vLRF8=EtqywCUyZmjW95Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu, Chris Mason <clm@fb.com>, jbacik@fb.com, dsterba@suse.com, linux-unionfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Josh Boyer <jwboyer@redhat.com>, dhowells@redhat.com
List-Id: linux-unionfs@vger.kernel.org

Hello,

For those who have received this message twice already, I sincerely apologize.

Yesterday I filed an issue in the CentOS bug tracker (#9297[1]) and
the Red Hat Bugzilla (#1255512[2]) about OverlayFS with Btrfs as the
upper layer.

The issue was discovered by a colleague of mine, and we verified the
issue exists in the EL7 kernel and mainline kernels (tested on Arch
Linux). I additionally verified the problem exists in Fedora kernels.

Rather than quoting the issue, I'll just note that the issue is
described quite well in the filed bugs noted earlier. In the linked
bugs, there's a simple Bash script that will reliably reproduce the
problem. While the script uses tmpfs at the lower layer, we originally
discovered the problem with ext4 as the lower layer and verified that
it doesn't matter which lower layer filesystem it is, the problem
exists. Additionally, the problem doesn't exist when using ext4 as the
upper layer.

I was advised by Josh Boyer to email you guys (and the mailing lists,
to be sure to get everyone a chance to look over it) about the
problem, since it affects mainline.

[1]: https://bugs.centos.org/view.php?id=9297
[2]: https://bugzilla.redhat.com/show_bug.cgi?id=1255512

-- 
Neal Gompa (FAS: ngompa)
