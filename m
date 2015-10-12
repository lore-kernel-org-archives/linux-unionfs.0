From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Issue: With an OverlayFS that has Btrfs as the upper layer,
 removal of directories silently fails
Date: Mon, 12 Oct 2015 17:37:53 +0200
Message-ID: <CAJfpeguQvARzwaUmKkQhuAL99S-JEeTQ8SiEujgcncyzg9x8-w@mail.gmail.com>
References: <CAEg-Je9o6QTyjD7pnSiTeUgaZjN10vLRF8=EtqywCUyZmjW95Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33484 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbbJLPhy (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 12 Oct 2015 11:37:54 -0400
Received: by oiar126 with SMTP id r126so37615097oia.0
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Oct 2015 08:37:54 -0700 (PDT)
In-Reply-To: <CAEg-Je9o6QTyjD7pnSiTeUgaZjN10vLRF8=EtqywCUyZmjW95Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Neal Gompa <ngompa@fedoraproject.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, dsterba@suse.com, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-btrfs@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>, David Howells <dhowells@redhat.com>

On Fri, Aug 21, 2015 at 9:23 PM, Neal Gompa <ngompa@fedoraproject.org> wrote:
> Hello,
>
> For those who have received this message twice already, I sincerely apologize.
>
> Yesterday I filed an issue in the CentOS bug tracker (#9297[1]) and
> the Red Hat Bugzilla (#1255512[2]) about OverlayFS with Btrfs as the
> upper layer.
>
> The issue was discovered by a colleague of mine, and we verified the
> issue exists in the EL7 kernel and mainline kernels (tested on Arch
> Linux). I additionally verified the problem exists in Fedora kernels.
>
> Rather than quoting the issue, I'll just note that the issue is
> described quite well in the filed bugs noted earlier. In the linked
> bugs, there's a simple Bash script that will reliably reproduce the
> problem. While the script uses tmpfs at the lower layer, we originally
> discovered the problem with ext4 as the lower layer and verified that
> it doesn't matter which lower layer filesystem it is, the problem
> exists. Additionally, the problem doesn't exist when using ext4 as the
> upper layer.
>
> I was advised by Josh Boyer to email you guys (and the mailing lists,
> to be sure to get everyone a chance to look over it) about the
> problem, since it affects mainline.
>
> [1]: https://bugs.centos.org/view.php?id=9297
> [2]: https://bugzilla.redhat.com/show_bug.cgi?id=1255512

AFAICS btrfs doesn't support RENAME_EXCHANGE and RENAME_WHITEOUT.
These flags are needed for any filesystem that wants to be a fully
functional  overlayfs upper layer.

Thanks,
Miklos
