From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 5/5] overlay: test mount error cases with exclusive directories
Date: Wed, 12 Jul 2017 14:53:21 +0300
Message-ID: <CAOQ4uxjiQeO3oaCyCHT7xnHjXiCdejse0FLOh2F0ZOvgbSDtWw@mail.gmail.com>
References: <1499802726-11045-1-git-send-email-amir73il@gmail.com>
 <1499802726-11045-6-git-send-email-amir73il@gmail.com> <20170712104741.GD7015@eguan.usersys.redhat.com>
 <CAOQ4uxhVQf+dP1_p6tqxbcMe__EsNMC_Wd16Vkh4LAmCJbRVNA@mail.gmail.com> <20170712114607.GF7015@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20170712114607.GF7015@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jul 12, 2017 at 2:46 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Jul 12, 2017 at 02:08:56PM +0300, Amir Goldstein wrote:
>> On Wed, Jul 12, 2017 at 1:47 PM, Eryu Guan <eguan@redhat.com> wrote:
>> > On Tue, Jul 11, 2017 at 10:52:06PM +0300, Amir Goldstein wrote:
>> >> Expect EBUSY when trying to mount overlay when:
>> >> - Upper dir is in-use by another overlay mount
>> >> - Work dir is in-use by another overlay mount
>> >>
>> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> >
>> > From patch 2/5, seems this behavior requires inode index feature to be
>> > enabled, and now test fails on old kernels for me. Is this expected?
>> >
>>
>> From my cover letter:
>> "The new test overlay/036 checks for new overlay mount behaviors related
>> to exclusivity of upper and work dirs among overlay mounts. This test
>> is expected to fail on upstream kernel, but for a good reason, because
>> the mount configurations that it tests (sharing upper dir among two
>> overlay mounts) are not wise at all."
>>
>> So the answer is yes, this is expected and also does not depend
>> on index feature.
>
> I usually read the cover letter (I saved it in my 'review' mailbox along
> with patches to review), but somehow I forgot about it this time..
>
>>
>> I know this is a bit confusing, but inode index enforces that 2
>> *subsequent* overlay
>> mount don't reuse the same upper/work dir with different lower/upper.
>> The test that checks this behavior is overlay/037, still on my
>> overlayfs-devel branch.
>>
>> overlay/036 verifies that 2 *concurrent* overlay mount don't reuse the same
>> upper/work dir. The is enforced by overlayfs-next regardless on index feature.
>> A setup like this will cause troubles in old kernel as well, but mount
>> will not detect it.
>
> Thanks for the explanation! The commit log and test description don't
> provide enough background information. If you could resend with detailed
> explanation on the test, that'd be great!
>
No problem.
