From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 3/3] generic/470: add syncfs test
Date: Mon, 11 Dec 2017 12:46:36 +0200
Message-ID: <CAOQ4uxjxtGd1+empZGX3OMXnYQoZ1YvL-HmKBUh3CBgFs2F1Aw@mail.gmail.com>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
 <1512613327-218016-3-git-send-email-cgxu519@icloud.com> <20171207054418.GC2749@eguan.usersys.redhat.com>
 <423B3F2E-73F1-4B29-93D7-BC6F1AA6CCC6@icloud.com> <20171207071317.GE2749@eguan.usersys.redhat.com>
 <EB49C2D0-6500-4588-803F-40F4B9FA6DE3@icloud.com> <CAOQ4uxgiqZBKUksWv-0gomKP4Ov7NB6zUw2TdnzUz7x6VUcpUw@mail.gmail.com>
 <E541A51A-D9B3-4596-8222-453132512449@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <E541A51A-D9B3-4596-8222-453132512449@icloud.com>
Sender: fstests-owner@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Dec 11, 2017 at 12:03 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
>>
>> =E5=9C=A8 2017=E5=B9=B412=E6=9C=887=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=884=
:17=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
[...]
>
> I did more detail tests for three different data modes of ext4 and found
> the overlayfs syncfs bug is reproducible on data=3Dordered and data=3Dwri=
teback,
> but on data=3Djournal mode, data is flushed and correct.

That is expected, because overlayfs does call upper's sync_fs() method and
for journal=3Ddata that will flush all dirty pages as well.

> I only wrote only a few words
> to a single file and the bug is always reproducible on my test environmen=
t.
>
> For writeback interferences, AFAIK, from dirty ratio and period.
> If we drop all dirty caches & sync before the test, I think we can
> avoid interference from it.
>

Why? does either drop_caches or sync() reset the flusher thread
periodic flush dirty pages?

> So if we don=E2=80=99t have anything else to interference test result,
> I just want to modify to write a small single file as test target.
>
> Am I missing anything?

I think the chance of flusher thread interfering the test and
flushing the dirty page you wrote before _scratch_shutdown exists,
but is small enough so we can neglect it and keep the test as simple
as possible.

Amir.
