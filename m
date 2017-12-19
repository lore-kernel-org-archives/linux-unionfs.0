From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v3] ovl: Check link ability between upperdir and workdir
Date: Tue, 19 Dec 2017 09:49:28 +0800
Message-ID: <C6350633-4F41-424F-B936-606CDAF2A8DF@icloud.com>
References: <1513601748-57439-1-git-send-email-cgxu519@icloud.com>
 <20171218160251.GA7474@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:25234 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933992AbdLSBto (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Dec 2017 20:49:44 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp001.me.com by
 pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P1600H00PJA6H00@pv33p36im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Tue, 19 Dec 2017 01:49:39 +0000 (GMT)
In-reply-to: <20171218160251.GA7474@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, amir73il@gmail.com, linux-unionfs@vger.kernel.org

>=20
> =D4=DA 2017=C4=EA12=D4=C219=C8=D5=A3=AC=C9=CF=CE=E712:02=A3=ACVivek =
Goyal <vgoyal@redhat.com> =D0=B4=B5=C0=A3=BA
>=20
> On Mon, Dec 18, 2017 at 08:55:48PM +0800, Chengguang Xu wrote:
>> Inspired by encountering unexpected write error when
>> upperdir and workdir having different project ids.
>=20
> Can you please make this problem descrition little better. By
> these two lines I really don't understand what's the problem
> you are trying to solve. All I understood was that upperdir
> and workdir had different project id. But not sure what
> problem it led to and why.
>=20
> In fact your first patch changelong was little better. It
> atleast said that you encounter "-EXDEV". So is it rename
> which fails. So rename is not allowed between two directories
> having different project ids?
>=20

The background is
I encountered an unexpected write error with error code -EXDEV in
my environment which didn=A1=AFt break any rules in overlayfs kernel
document.

So I did some investigations and found when upperdir and workdir
having different project quotas then rename/link operations between
those directories would be fail with -EXDEV because project quota
asks files in it strictly inherit project id with it=A1=AFs own. This =
will
make write fail during copy-up process.

I wrote first patch to check this condition, but that check seems not
sufficient to detect write error, so after discussion with Amir,
we decided to check link ability between upperdir and workdir, it is
what copy-up actually doing when modifying files in lowerdirs, and also
I decided to only print a warning message instead of directly mounting
on read-only mode in case there is a special use case just read and do =
not=20
modify anything in lowerdirs.



Thanks,
Chengguang.
