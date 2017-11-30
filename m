From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] generic/470: Add check for different sync modes
Date: Thu, 30 Nov 2017 10:08:34 +0200
Message-ID: <CAOQ4uxio1HkdCsWRaVBQxZ3aGNT9_5yfPbU552dmYqLbVt_LeA@mail.gmail.com>
References: <1512009801-11466-1-git-send-email-cgxu@mykernel.net>
 <CAOQ4uxgnenGaEXnNSjovnF+r06rjV4_VdR4qhaXs5q4yexu=jA@mail.gmail.com> <20171130072228.GT2749@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="94eb2c129b0a3d635b055f2ec27f"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:36025 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdK3IIg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Nov 2017 03:08:36 -0500
In-Reply-To: <20171130072228.GT2749@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Chengguang Xu <cgxu@mykernel.net>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

--94eb2c129b0a3d635b055f2ec27f
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 30, 2017 at 9:22 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Thu, Nov 30, 2017 at 07:30:41AM +0200, Amir Goldstein wrote:
>> Adding fstests list and maintainer in CC, because this is where this
>> patch in meant to go.
>>
>> Eryu,
>>
>> This test is expected to fail with overlayfs on current upstream and
>> any past version
>> AFAIK.
>> Do you this it qualifies for a specific overlay/* regression test? or
>> that generic/* test
>> would be sufficient to cover the overlayfs issue?
>
> If it reproduces the overlay bug without any special overlay setup, a
> generic test would be good, other filesystems could benefit from this
> test too.
>
> And Chengguang, can you please send the full version of the test to
> fstests@vger.kernel.org again? I can only see and comment on the trimmed
> version now.

Yeh, sorry about that. Attaching patch here until v2 is posted to fstests.


>>
>> On Thu, Nov 30, 2017 at 4:43 AM, Chengguang Xu <cgxu@mykernel.net> wrote:
>> > generic/470 should be skipped when delalloc is not supported.
>
> What happens if there's no delalloc support? If test fails due to that's
> not a valid setup or wrong usage of overlay (I highly doubt it :), I
> agree we should _notrun in this case. If test passes without reproducing
> the bug, I'd prefer continuing run the test to get better test coverage,
> just write comments to describe this case.
>
>> >
>>
>> Test looks very good. One minor nit below.
>>
>>
>> Not sure why you choose the minor detail in the line above as the
>> commit description?
>> Seems like the text in the top comment of the test would have been also
>> appropriate for commit description.
>
> Yeah, please describe the test purpose in commit log, if you're testing
> a specific overlay bug, describe that bug too and refering to the patch
> that fixed the bug would be good. And it's worth mentioning the test
> behavior when delalloc is not supported.
>

Test is not_run when delalloc is not supported.
I should explain.
This test is inspired by a simple test script I wrote
https://github.com/amir73il/overlayfs/blob/master/tests/xfs_syncfs.sh

At the time when I *thought* I fixed syncfs, I couldn't figure out a way
to write a generic test so I left it at that.

The delalloc trick, which I recently added to the script is just a very cheap
way of testing that inode pages are flushed.
If fs doesn't support delalloc, then test would have to use dm-flakey or a like
and compare size/md5sum on disk to expected.
That is a much more heavy weight test and I can't think of how to combine
dm-flakey setup with overlay setup.

It is just too much of a hustle considering that the delalloc trick is so cheap
and works on several major fs.


>>
>> > Signed-off-by: Chengguang Xu <cgxu@mykernel.net>
>> > ---
>> >  tests/generic/470     | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++
>> >  tests/generic/470.out |   2 +
>> >  tests/generic/group   |   1 +
>> >  3 files changed, 136 insertions(+)
>> >  create mode 100755 tests/generic/470
>> >  create mode 100644 tests/generic/470.out
>> >
>> > diff --git a/tests/generic/470 b/tests/generic/470
>> > new file mode 100755
>> > index 0000000..a43fb91
>> > --- /dev/null
>> > +++ b/tests/generic/470
>> > @@ -0,0 +1,133 @@
>> > +#! /bin/bash
>> > +# FS QA Test No. 470
>> > +#
>> > +# Run fsync & fdatasync & syncfs & sync to test sync result.
>> > +#
>> > +#-----------------------------------------------------------------------
>> > +# Copyright (c) 2017 Chengguang Xu <cgxu@mykernel.net>. All Rights Reserved.
>> > +#
>> > +# This program is free software; you can redistribute it and/or
>> > +# modify it under the terms of the GNU General Public License as
>> > +# published by the Free Software Foundation.
>> > +#
>> > +# This program is distributed in the hope that it would be useful,
>> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> > +# GNU General Public License for more details.
>> > +#
>> > +# You should have received a copy of the GNU General Public License
>> > +# along with this program; if not, write the Free Software Foundation,
>> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> > +#-----------------------------------------------------------------------
>> > +
>> > +seq=`basename $0`
>> > +seqres=$RESULT_DIR/$seq
>> > +echo "QA output created by $seq"
>> > +
>> > +here=`pwd`
>> > +tmp=/tmp/$$
>> > +status=0
>> > +trap "_cleanup; exit \$status" 0 1 2 3 15
>> > +
>> > +_cleanup()
>> > +{
>> > +       cd /
>> > +       rm -f $tmp.*
>> > +}
>> > +
>> > +# get standard environment, filters and checks
>> > +. ./common/rc
>> > +. ./common/filter
>> > +
>> > +# remove previous $seqres.full before test
>> > +rm -f $seqres.full
>> > +
>> > +# real QA test starts here
>> > +
>> > +# Modify as appropriate.
>> > +_supported_fs generic
>> > +_supported_os Linux
>> > +_require_test
>> > +_require_xfs_io_command "fsync"
>> > +_require_xfs_io_command "fdatasync"
>> > +_require_xfs_io_command "syncfs"
>> > +_require_xfs_io_command "sync"
>
> Seems not necessary except the "syncfs" case, as older kernel doesn't
> support syncfs(2), but I think there's nothing wrong with having them
> checked explicitly.
>

Actually, it is quite not nice not to run the test on old kernels.
Better check for availability of syncfs and if it exists add it to
SYNC_MODES to be tested.

>> > +_require_command "$FILEFRAG_PROG" filefrag
>> > +
>> > +PREFIX=$TEST_DIR/${seq}-testfile
>> > +TESTFILES=$TEST_DIR/${seq}-testfile-*
>
> Why not just use $PREFIX-*?
>
>> > +FCNT=1000
>> > +
>> > +write_data()
>> > +{
>> > +       rm -f $TESTFILES >/dev/null 2>&1
>> > +       for i in `seq 1 $FCNT`; do
>> > +               $XFS_IO_PROG -f -c "pwrite 1K 1K" \
>> > +                               ${PREFIX}-$i >/dev/null 2>&1
>> > +       done
>> > +}
>> > +
>> > +check_delalloc_support()
>> > +{
>> > +       write_data
>> > +       $FILEFRAG_PROG -e $TESTFILES | grep -w delalloc >/dev/null 2>&1
>
> This looks fragile and requires all the files are not written back to
> disk, it's unlikely but still possible someone flushed the files before
> filefrag run.
>
> Anyway, I think this function can be dropped if we decide continue to
> run test if delalloc is not supported.
>

This test does not guaranty failure on buggy fs, but it does provide
very very high
probability of failure on buggy fs. Anything else would be much more
complicated.
Anything else would also not be as quick, because it will require writing large
amounts of data and waiting for sync/fsync/syncfs to flush them after
every write.

I suggest to merge this test as is and add commentary about the possibility
of false negative.

Chengguang may continue to work on another test that is more reliable and
doesn't require delalloc support if he chooses to.

Thanks,
Amir.

--94eb2c129b0a3d635b055f2ec27f
Content-Type: text/x-patch; charset="US-ASCII"; name="fstests-delalloc-sync.patch"
Content-Disposition: attachment; filename="fstests-delalloc-sync.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jam6qpui0

RGVsaXZlcmVkLVRvOiBhbWlyNzNpbEBnbWFpbC5jb20NClJlY2VpdmVkOiBieSAxMC4xMjkuMTEy
LjEwIHdpdGggU01UUCBpZCBsMTBjc3AyNDgyNXl3YzsNCiAgICAgICAgV2VkLCAyOSBOb3YgMjAx
NyAxODo0NDo0MiAtMDgwMCAoUFNUKQ0KWC1Hb29nbGUtU210cC1Tb3VyY2U6IEFHczR6TWJYL3FT
Ti9leUdib09Ka2h0b0hUSnQzbC9JaTU1Z1c3TjBWUTNmT0phWEJqcUhUTFhuNWt3eFNiKzB0ZWFm
WW5HWFErOXINClgtUmVjZWl2ZWQ6IGJ5IDEwLjE1Ny4yNS4yMzkgd2l0aCBTTVRQIGlkIGsxMDJt
cjQwOTMwNDhvdGsuMzQyLjE1MTIwMDk4ODIxNzE7DQogICAgICAgIFdlZCwgMjkgTm92IDIwMTcg
MTg6NDQ6NDIgLTA4MDAgKFBTVCkNCkFSQy1TZWFsOiBpPTE7IGE9cnNhLXNoYTI1NjsgdD0xNTEy
MDA5ODgyOyBjdj1ub25lOw0KICAgICAgICBkPWdvb2dsZS5jb207IHM9YXJjLTIwMTYwODE2Ow0K
ICAgICAgICBiPUxDMlo0cWVqbFdXMkNPZFdWcHZUT2ZrYWtkMlBxdzFLbndmTGtZdEtORkxSUlV4
ZDUvT2ltSjk4Z09qTHRZVHZtdA0KICAgICAgICAgMVZhT21tdG56aTkxUjJ2NEdLcEw0SDRKZ1I5
UXFKc2tLbmpPUFlKczVEdG0wWUZQWHRPQitmSWVYbEswdnpqVitNSWINCiAgICAgICAgIHNHR0pG
ejFMSFFaeWkwSWlVUDdVb2VCZGc5RkVzYjdCVjFZeGY3M0Y5dEFYU0dGOHVFazIvcGdiQ0JjYjZj
RE11OXlMDQogICAgICAgICAyVjNtSUhmbG9CRUx6Vnk4aHAvUWNwbUhqZ1VyRU1hT2UxMWxoUEVn
WTljaE85Q29yQmRzaHNCSU1rRGpJU3pBcVRZbA0KICAgICAgICAgbTVIbTlVaU1jM1JkbnplUk5H
MSt2MUtPNWRyUkVKd1VDVEdhbzVPWTFiMS9pdndnK3FURjVBcjVwZzdzSGlQMTFBRk0NCiAgICAg
ICAgIDlvSWc9PQ0KQVJDLU1lc3NhZ2UtU2lnbmF0dXJlOiBpPTE7IGE9cnNhLXNoYTI1NjsgYz1y
ZWxheGVkL3JlbGF4ZWQ7IGQ9Z29vZ2xlLmNvbTsgcz1hcmMtMjAxNjA4MTY7DQogICAgICAgIGg9
bWVzc2FnZS1pZDpkYXRlOnN1YmplY3Q6Y2M6dG86ZnJvbTphcmMtYXV0aGVudGljYXRpb24tcmVz
dWx0czsNCiAgICAgICAgYmg9QmxVQmphV0FtQ2g3TU04MFVQSTVrTTlrMThKeUlIaGZvbi9RNmJ1
NWFIRT07DQogICAgICAgIGI9VDV3amlzSkNhMGNkZUJXczEyYjNUdnRyZzIrV05vcEwzQU14elBo
WmlwNjFkM2dyMWxpZ2lidldZczl4Rjl2VDJKDQogICAgICAgICB0d3VMdjVlQUlXd3Vja2FzZy9P
SmNwRExFMytHTkxiejNLbVRSVzEwWWxNaWdtVjRxZmYzbkFMTnVsOWtFOUphRks1Rw0KICAgICAg
ICAgcTNUZjZnZlJRSXR6bDRVSEJwSkFiSCsrakwwSnZCaTloK09oRUlwUk9ldFpsZGdVOUppWlVr
NDFiT0tmT1daajBjVjYNCiAgICAgICAgIHNZTWx2SkpTdUl1ZDh0ZFFrL2NRWDB3SWlOOEJKTDdo
VGtuakZYQVlRS3NTK1dYcTVER0tZRnRWQ2ZQUXNDZmo4cWpNDQogICAgICAgICBTZy83M04xOHk2
R1l5RVJZNWptT0JQdnpnNlV4N2hScnhUYjlLaW84UVNucitqWmxNZFFqNFlkekovdzdHQjVWV1Uw
bg0KICAgICAgICAga2JWUT09DQpBUkMtQXV0aGVudGljYXRpb24tUmVzdWx0czogaT0xOyBteC5n
b29nbGUuY29tOw0KICAgICAgIHNwZj1uZXV0cmFsIChnb29nbGUuY29tOiAxMjIuMjI1LjgxLjEz
NCBpcyBuZWl0aGVyIHBlcm1pdHRlZCBub3IgZGVuaWVkIGJ5IGJlc3QgZ3Vlc3MgcmVjb3JkIGZv
ciBkb21haW4gb2YgY2d4dUBqdWFubml1MDE4MDM3LnNzLm1vZ3VqaWUub3JnKSBzbXRwLm1haWxm
cm9tPWNneHVAanVhbm5pdTAxODAzNy5zcy5tb2d1amllLm9yZw0KUmV0dXJuLVBhdGg6IDxjZ3h1
QGp1YW5uaXUwMTgwMzcuc3MubW9ndWppZS5vcmc+DQpSZWNlaXZlZDogZnJvbSBqdWFubml1MDE4
MDM3LnNzLm1vZ3VqaWUub3JnIChbMTIyLjIyNS44MS4xMzRdKQ0KICAgICAgICBieSBteC5nb29n
bGUuY29tIHdpdGggRVNNVFBTIGlkIHUxNDRzaTk0OTk1N29pZi41MTkuMjAxNy4xMS4yOS4xOC40
NC4zOA0KICAgICAgICBmb3IgPGFtaXI3M2lsQGdtYWlsLmNvbT4NCiAgICAgICAgKHZlcnNpb249
VExTMV8yIGNpcGhlcj1FQ0RIRS1SU0EtQUVTMTI4LUdDTS1TSEEyNTYgYml0cz0xMjgvMTI4KTsN
CiAgICAgICAgV2VkLCAyOSBOb3YgMjAxNyAxODo0NDo0MSAtMDgwMCAoUFNUKQ0KUmVjZWl2ZWQt
U1BGOiBuZXV0cmFsIChnb29nbGUuY29tOiAxMjIuMjI1LjgxLjEzNCBpcyBuZWl0aGVyIHBlcm1p
dHRlZCBub3IgZGVuaWVkIGJ5IGJlc3QgZ3Vlc3MgcmVjb3JkIGZvciBkb21haW4gb2YgY2d4dUBq
dWFubml1MDE4MDM3LnNzLm1vZ3VqaWUub3JnKSBjbGllbnQtaXA9MTIyLjIyNS44MS4xMzQ7DQpB
dXRoZW50aWNhdGlvbi1SZXN1bHRzOiBteC5nb29nbGUuY29tOw0KICAgICAgIHNwZj1uZXV0cmFs
IChnb29nbGUuY29tOiAxMjIuMjI1LjgxLjEzNCBpcyBuZWl0aGVyIHBlcm1pdHRlZCBub3IgZGVu
aWVkIGJ5IGJlc3QgZ3Vlc3MgcmVjb3JkIGZvciBkb21haW4gb2YgY2d4dUBqdWFubml1MDE4MDM3
LnNzLm1vZ3VqaWUub3JnKSBzbXRwLm1haWxmcm9tPWNneHVAanVhbm5pdTAxODAzNy5zcy5tb2d1
amllLm9yZw0KUmVjZWl2ZWQ6IGZyb20ganVhbm5pdTAxODAzNy5zcy5tb2d1amllLm9yZyAobG9j
YWxob3N0IFsxMjcuMC4wLjFdKQ0KCWJ5IGp1YW5uaXUwMTgwMzcuc3MubW9ndWppZS5vcmcgKDgu
MTQuNy84LjE0LjcpIHdpdGggRVNNVFAgaWQgdkFVMmhXb28wMTE1NjM7DQoJVGh1LCAzMCBOb3Yg
MjAxNyAxMDo0MzozMiArMDgwMA0KUmVjZWl2ZWQ6IChmcm9tIGNneHVAbG9jYWxob3N0KQ0KCWJ5
IGp1YW5uaXUwMTgwMzcuc3MubW9ndWppZS5vcmcgKDguMTQuNy84LjE0LjcvU3VibWl0KSBpZCB2
QVUyaFZIRTAxMTU2MjsNCglUaHUsIDMwIE5vdiAyMDE3IDEwOjQzOjMxICswODAwDQpGcm9tOiBD
aGVuZ2d1YW5nIFh1IDxjZ3h1QG15a2VybmVsLm5ldD4NClRvOiBhbWlyNzNpbEBnbWFpbC5jb20N
CkNjOiBsaW51eC11bmlvbmZzQHZnZXIua2VybmVsLm9yZywgQ2hlbmdndWFuZyBYdSA8Y2d4dUBt
eWtlcm5lbC5uZXQ+DQpTdWJqZWN0OiBbUEFUQ0hdIGdlbmVyaWMvNDcwOiBBZGQgY2hlY2sgZm9y
IGRpZmZlcmVudCBzeW5jIG1vZGVzDQpEYXRlOiBUaHUsIDMwIE5vdiAyMDE3IDEwOjQzOjIxICsw
ODAwDQpNZXNzYWdlLUlkOiA8MTUxMjAwOTgwMS0xMTQ2Ni0xLWdpdC1zZW5kLWVtYWlsLWNneHVA
bXlrZXJuZWwubmV0Pg0KWC1NYWlsZXI6IGdpdC1zZW5kLWVtYWlsIDEuOC4zLjENCg0KZ2VuZXJp
Yy80NzAgc2hvdWxkIGJlIHNraXBwZWQgd2hlbiBkZWxhbGxvYyBpcyBub3Qgc3VwcG9ydGVkLg0K
DQpTaWduZWQtb2ZmLWJ5OiBDaGVuZ2d1YW5nIFh1IDxjZ3h1QG15a2VybmVsLm5ldD4NCi0tLQ0K
IHRlc3RzL2dlbmVyaWMvNDcwICAgICB8IDEzMyArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKw0KIHRlc3RzL2dlbmVyaWMvNDcwLm91dCB8ICAgMiArDQog
dGVzdHMvZ2VuZXJpYy9ncm91cCAgIHwgICAxICsNCiAzIGZpbGVzIGNoYW5nZWQsIDEzNiBpbnNl
cnRpb25zKCspDQogY3JlYXRlIG1vZGUgMTAwNzU1IHRlc3RzL2dlbmVyaWMvNDcwDQogY3JlYXRl
IG1vZGUgMTAwNjQ0IHRlc3RzL2dlbmVyaWMvNDcwLm91dA0KDQpkaWZmIC0tZ2l0IGEvdGVzdHMv
Z2VuZXJpYy80NzAgYi90ZXN0cy9nZW5lcmljLzQ3MA0KbmV3IGZpbGUgbW9kZSAxMDA3NTUNCmlu
ZGV4IDAwMDAwMDAuLmE0M2ZiOTENCi0tLSAvZGV2L251bGwNCisrKyBiL3Rlc3RzL2dlbmVyaWMv
NDcwDQpAQCAtMCwwICsxLDEzMyBAQA0KKyMhIC9iaW4vYmFzaA0KKyMgRlMgUUEgVGVzdCBOby4g
NDcwDQorIyANCisjIFJ1biBmc3luYyAmIGZkYXRhc3luYyAmIHN5bmNmcyAmIHN5bmMgdG8gdGVz
dCBzeW5jIHJlc3VsdC4NCisjDQorIy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQorIyBDb3B5cmlnaHQgKGMpIDIw
MTcgQ2hlbmdndWFuZyBYdSA8Y2d4dUBteWtlcm5lbC5uZXQ+LiBBbGwgUmlnaHRzIFJlc2VydmVk
Lg0KKyMNCisjIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJp
YnV0ZSBpdCBhbmQvb3INCisjIG1vZGlmeSBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBH
ZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzDQorIyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdh
cmUgRm91bmRhdGlvbi4NCisjDQorIyBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhl
IGhvcGUgdGhhdCBpdCB3b3VsZCBiZSB1c2VmdWwsDQorIyBidXQgV0lUSE9VVCBBTlkgV0FSUkFO
VFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZg0KKyMgTUVSQ0hBTlRBQklM
SVRZIG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZQ0KKyMgR05V
IEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4NCisjDQorIyBZb3Ugc2hv
dWxkIGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5z
ZQ0KKyMgYWxvbmcgd2l0aCB0aGlzIHByb2dyYW07IGlmIG5vdCwgd3JpdGUgdGhlIEZyZWUgU29m
dHdhcmUgRm91bmRhdGlvbiwNCisjIEluYy4sICA1MSBGcmFua2xpbiBTdCwgRmlmdGggRmxvb3Is
IEJvc3RvbiwgTUEgIDAyMTEwLTEzMDEgIFVTQQ0KKyMtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKw0KK3NlcT1g
YmFzZW5hbWUgJDBgDQorc2VxcmVzPSRSRVNVTFRfRElSLyRzZXENCitlY2hvICJRQSBvdXRwdXQg
Y3JlYXRlZCBieSAkc2VxIg0KKw0KK2hlcmU9YHB3ZGANCit0bXA9L3RtcC8kJA0KK3N0YXR1cz0w
DQordHJhcCAiX2NsZWFudXA7IGV4aXQgXCRzdGF0dXMiIDAgMSAyIDMgMTUNCisNCitfY2xlYW51
cCgpDQorew0KKwljZCAvDQorCXJtIC1mICR0bXAuKg0KK30NCisNCisjIGdldCBzdGFuZGFyZCBl
bnZpcm9ubWVudCwgZmlsdGVycyBhbmQgY2hlY2tzDQorLiAuL2NvbW1vbi9yYw0KKy4gLi9jb21t
b24vZmlsdGVyDQorDQorIyByZW1vdmUgcHJldmlvdXMgJHNlcXJlcy5mdWxsIGJlZm9yZSB0ZXN0
DQorcm0gLWYgJHNlcXJlcy5mdWxsDQorDQorIyByZWFsIFFBIHRlc3Qgc3RhcnRzIGhlcmUNCisN
CisjIE1vZGlmeSBhcyBhcHByb3ByaWF0ZS4NCitfc3VwcG9ydGVkX2ZzIGdlbmVyaWMNCitfc3Vw
cG9ydGVkX29zIExpbnV4DQorX3JlcXVpcmVfdGVzdA0KK19yZXF1aXJlX3hmc19pb19jb21tYW5k
ICJmc3luYyINCitfcmVxdWlyZV94ZnNfaW9fY29tbWFuZCAiZmRhdGFzeW5jIg0KK19yZXF1aXJl
X3hmc19pb19jb21tYW5kICJzeW5jZnMiDQorX3JlcXVpcmVfeGZzX2lvX2NvbW1hbmQgInN5bmMi
DQorX3JlcXVpcmVfY29tbWFuZCAiJEZJTEVGUkFHX1BST0ciIGZpbGVmcmFnDQorDQorUFJFRklY
PSRURVNUX0RJUi8ke3NlcX0tdGVzdGZpbGUNCitURVNURklMRVM9JFRFU1RfRElSLyR7c2VxfS10
ZXN0ZmlsZS0qDQorRkNOVD0xMDAwDQorDQord3JpdGVfZGF0YSgpDQorew0KKwlybSAtZiAkVEVT
VEZJTEVTID4vZGV2L251bGwgMj4mMQ0KKwlmb3IgaSBpbiBgc2VxIDEgJEZDTlRgOyBkbw0KKwkJ
JFhGU19JT19QUk9HIC1mIC1jICJwd3JpdGUgMUsgMUsiIFwNCisJCQkJJHtQUkVGSVh9LSRpID4v
ZGV2L251bGwgMj4mMQ0KKwlkb25lDQorfQ0KKw0KK2NoZWNrX2RlbGFsbG9jX3N1cHBvcnQoKQ0K
K3sNCisJd3JpdGVfZGF0YQ0KKwkkRklMRUZSQUdfUFJPRyAtZSAkVEVTVEZJTEVTIHwgZ3JlcCAt
dyBkZWxhbGxvYyA+L2Rldi9udWxsIDI+JjENCisJaWYgWyAkPyAtbmUgMCBdOyB0aGVuDQorCQlf
bm90cnVuICJUaGlzIHRlc3QgcmVxdWlyZXMgZGVsYXllZCBhbGxvY2F0aW9uIHN1cHBvcnQhIg0K
KwlmaQ0KK30NCisNCitzeW5jX2RhdGEoKQ0KK3sNCisJY2FzZSAkMSBpbg0KKwlzeW5jKQ0KKwkJ
JFhGU19JT19QUk9HIC1jICJzeW5jIiA+L2Rldi9udWxsIDI+JjENCisJCTs7DQorCXN5bmNmcykN
CisJCSRYRlNfSU9fUFJPRyAtYyAic3luY2ZzIiAke1BSRUZJWH0tJHtGQ05UfSA+L2Rldi9udWxs
IDI+JjENCisJCTs7DQorCWZzeW5jKQ0KKwkJZm9yIGkgaW4gYHNlcSAxICRGQ05UYDsgZG8NCisJ
CQkkWEZTX0lPX1BST0cgLWMgImZzeW5jIiAke1BSRUZJWH0tJHtpfSA+L2Rldi9udWxsIDI+JjEN
CisJCWRvbmUNCisJCTs7DQorCWZkYXRhc3luYykNCisJCWZvciBpIGluIGBzZXEgMSAkRkNOVGA7
IGRvDQorCQkJJFhGU19JT19QUk9HIC1jICJmZGF0YXN5bmMiICR7UFJFRklYfS0ke2l9ID4vZGV2
L251bGwgMj4mMQ0KKwkJZG9uZQ0KKwkJOzsNCisJKikNCisJCTs7DQorCWVzYWMNCit9DQorDQor
Y2hlY2tfZGF0YSgpDQorew0KKwkkRklMRUZSQUdfUFJPRyAtZSAkVEVTVEZJTEVTIHwgZ3JlcCAt
dyBkZWxhbGxvYyAyPi9kZXYvbnVsbA0KKwlpZiBbICQ/IC1lcSAwIF07IHRoZW4NCisJCXN0YXR1
cz0xDQorCWZpDQorfQ0KKw0KK3Rlc3Rfc3luYygpDQorew0KKwlsb2NhbCBzeW5jX21vZGU9JDEN
CisNCisJaWYgWyAkc3luY19tb2RlID0gInN5bmMiIF07IHRoZW4NCisJCWVjaG8gMyA+IC9wcm9j
L3N5cy92bS9kcm9wX2NhY2hlcw0KKwlmaQ0KKw0KKwl3cml0ZV9kYXRhDQorCXN5bmNfZGF0YSAk
c3luY19tb2RlDQorCWNoZWNrX2RhdGENCit9DQorDQorY2hlY2tfZGVsYWxsb2Nfc3VwcG9ydA0K
Kw0KK2ZvciBpIGluIGZzeW5jIGZkYXRhc3luYyBzeW5jZnMgc3luYzsgZG8NCisJdGVzdF9zeW5j
ICRpDQorZG9uZQ0KKw0KK3JtIC1mICRURVNURklMRVMgPi9kZXYvbnVsbCAyPiYxDQorDQorZWNo
byAiU2lsZW5jZSBpcyBnb2xkZW4iDQorZXhpdCAkc3RhdHVzDQpkaWZmIC0tZ2l0IGEvdGVzdHMv
Z2VuZXJpYy80NzAub3V0IGIvdGVzdHMvZ2VuZXJpYy80NzAub3V0DQpuZXcgZmlsZSBtb2RlIDEw
MDY0NA0KaW5kZXggMDAwMDAwMC4uNzlmYjUzMg0KLS0tIC9kZXYvbnVsbA0KKysrIGIvdGVzdHMv
Z2VuZXJpYy80NzAub3V0DQpAQCAtMCwwICsxLDIgQEANCitRQSBvdXRwdXQgY3JlYXRlZCBieSA0
NzANCitTaWxlbmNlIGlzIGdvbGRlbg0KZGlmZiAtLWdpdCBhL3Rlc3RzL2dlbmVyaWMvZ3JvdXAg
Yi90ZXN0cy9nZW5lcmljL2dyb3VwDQppbmRleCA2YzNiYjAzLi4yM2UzMjVjIDEwMDY0NA0KLS0t
IGEvdGVzdHMvZ2VuZXJpYy9ncm91cA0KKysrIGIvdGVzdHMvZ2VuZXJpYy9ncm91cA0KQEAgLTQ3
MiwzICs0NzIsNCBAQA0KIDQ2NyBhdXRvIHF1aWNrIGV4cG9ydGZzDQogNDY4IHNodXRkb3duIGF1
dG8gcXVpY2sgbWV0YWRhdGENCiA0NjkgYXV0byBxdWljaw0KKzQ3MCBhdXRvIHF1aWNrIHN5bmMN
Ci0tIA0KMS44LjMuMQ0KDQo=
--94eb2c129b0a3d635b055f2ec27f--
