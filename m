Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46488 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbeKHUVt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Nov 2018 15:21:49 -0500
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH] tmpfs: let lseek return ENXIO with a negative offset
From: William Kucharski <william.kucharski@oracle.com>
In-Reply-To: <20181107151955.777fcbcf9a5932677e245287@linux-foundation.org>
Date: Thu, 8 Nov 2018 03:46:35 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <EDFDF8C6-F164-4C5A-A5D3-010802D02DC2@oracle.com>
References: <1540434176-14349-1-git-send-email-yuyufen@huawei.com>
 <20181107151955.777fcbcf9a5932677e245287@linux-foundation.org>
Sender: linux-unionfs-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yufen Yu <yuyufen@huawei.com>, viro@zeniv.linux.org.uk, hughd@google.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>



> On Nov 7, 2018, at 4:19 PM, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> man 2 lseek says
>=20
> :      EINVAL whence  is  not  valid.   Or: the resulting file offset =
would be
> :             negative, or beyond the end of a seekable device.
> :
> :      ENXIO  whence is SEEK_DATA or SEEK_HOLE, and the file offset is =
 beyond
> :             the end of the file.
>=20
>=20
> Make tmpfs return ENXIO under these circumstances as well.  After =
this,
> tmpfs also passes xfstests's generic/448.

As I objected to last week, despite the fact that other file systems do =
this, is
this in fact the desired behavior?

I'll let you reread that message rather than repeat it in its entirety =
here, but
certainly a negative offset is not "beyond the end of the file," and the =
end
result is errno is set to ENXIO for a reason that does not match what =
the
lseek(2) man page describes.

I also mentioned if a negative offset is used with SEEK_CUR or =
SEEK_WHENCE,
arguably the negative offset should actually be treated as "0" given =
lseek(2)
also states:

      SEEK_DATA
             Adjust the file offset to the next location in the file
             greater than or equal to offset containing data.  If offset
             points to data, then the file offset is set to offset.

      SEEK_HOLE
             Adjust the file offset to the next hole in the file greater
             than or equal to offset.  If offset points into the middle =
of
             a hole, then the file offset is set to offset.  If there is =
no
             hole past offset, then the file offset is adjusted to the =
end
             of the file (i.e., there is an implicit hole at the end of =
any
             file).

Since the "next location" or "next hole" will never be at a negative =
offset, the
"greater than" clause of both descriptions would mean the resulting =
offset should
be treated as if it were passed as zero.

However, if xfstest-compliant behavior is desired, the lseek(2) man page
description for ENXIO should be updated to something like:

       ENXIO  whence is SEEK_DATA or SEEK_HOLE, and the file offset is =
negative or
              beyond the end of the file.

I don't mean to be pedantic, but I also know how frustrating it can be =
when a system
call returns with errno set for a reason that doesn't correspond to the =
man page.

    Thanks,
         William Kucharski=
