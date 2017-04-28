From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 4/6] overlay/017: create helpers to record and check
 inode numbers
Date: Fri, 28 Apr 2017 13:04:08 +0300
Message-ID: <CAOQ4uxiTJDQj4YNnaHY6AYvYAv+QF+bE4EPWC0K09hyNU6k4oA@mail.gmail.com>
References: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
 <1493367888-26550-5-git-send-email-amir73il@gmail.com> <20170428092402.GQ26397@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20170428092402.GQ26397@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Apr 28, 2017 at 12:24 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Fri, Apr 28, 2017 at 11:24:46AM +0300, Amir Goldstein wrote:
>> Use helpers to records and check inode numbers so we can repeat
>> the same test after rename and mount cycle.
>>
>> Suggested-by: Eryu Guan <eguan@redhat.com>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  tests/overlay/017 | 57 ++++++++++++++++++++++++++++++++++++++++---------------
>>  1 file changed, 42 insertions(+), 15 deletions(-)
>>
>> diff --git a/tests/overlay/017 b/tests/overlay/017
>> index 779907d..3ff429f 100755
>> --- a/tests/overlay/017
>> +++ b/tests/overlay/017
>> @@ -72,32 +72,59 @@ mknod $lowerdir/blkdev b 1 1
>>  mknod $lowerdir/fifo p
>>  $here/src/af_unix $lowerdir/socket
>>
>> +FILES="dir file symlink chrdev blkdev fifo socket"
>> +
>> +# Record inode numbers in format <ino> <basename>
>> +function record_inode_numbers()
>> +{
>> +     dir=$1
>> +     outfile=$2
>> +
>> +     for f in $FILES; do
>> +             ls -id $dir/$f
>> +     done | \
>> +     while read ino file; do
>> +             echo $ino `basename $file` >> $outfile
>> +     done
>> +}
>> +
>> +# Check inode numbers match recorder inode numbers
>> +function check_inode_numbers()
>> +{
>> +     dir=$1
>> +     before=$2
>> +     after=$2
>              ^^^ $3
> Otherwise looks good to me. I can fix this typo at commit time.

Oh boy! That's a lousy test :-)
Now I wonder why the test failed when I ran it on kernel v4.10
(when feeding after to find -inum)... something for me to check.

>
> But I've already kicked off release testing for this week's update,
> I'll queue these patches for next update.
>

Sure. No rush on my end.

Thanks,
Amir.
