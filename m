From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/7] open_by_handle: store and load file handles from file
Date: Thu, 11 Jan 2018 17:59:01 +0200
Message-ID: <CAOQ4uxjxxMo=uQn93T3mpCy3_o-5_TKGc08ugqFYH5fk=3Cn2Q@mail.gmail.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
 <1515348445-1403-2-git-send-email-amir73il@gmail.com> <20180111115904.GL5123@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180111115904.GL5123@eguan.usersys.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jan 11, 2018 at 1:59 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Sun, Jan 07, 2018 at 08:07:19PM +0200, Amir Goldstein wrote:
>> usage:
>>  open_by_handle -p -o <handles_file> <test_dir> [N]
>>  open_by_handle -p -i <handles_file> <test_dir> [N]
>>
>> This will be used to test decoding of file handles after various
>> file systems operations including mount cycle.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> I found that it might be easier to review if the new test that takes use
> of this new function is included in the same patch, so reviewer could
> know how are these new functions being used without switching between
> different patches.
>

Eryu,

Thanks for your comments. I will fix them later, but let me first address
this meta comment, so maybe it will help you with review of the tests.

I find that the comment about posting the new functionality along with the
test would have been a good thing to do for most of the options I added
so far. It could be a good option for this test as well.
However, the -i -o options are quite generic in nature, so it should
be fine to explain them without a test, only I probably did not explain well.

The basic flow of open_by_handle program is:
- store file handle of parent and test files in memory array
- perform operations on files
- drop caches
- open by file handles from array
- perform tests on open files

-i -o options allow to perform name_to_handle and open_by_handle with
2 different program invocations, so you don't need to rely on the program
performing drop caches and you can test advances flows like:
- encode files
- cycle mount
- decode files

In my use case, the new tests in generic/467 are:
- ecnode parent and files
- rename parent
- decode parent and files

- encode files
- move files to new parent
- decode files

- ecnode parent and files
- rename grandparent
- decode parent and files

Cheers,
Amir.
